class ConversationsController < ApplicationController
  include Constants
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
  #before_action :require_user, only: [:index, :search, :show]


  def search
    @conversations = []
    @conversation_highlights = {}
    keyword = remove_conjunctions_and_articles(params[:keyword])
    @tag_filter = params[:tag_filter]

    if keyword.blank?
      @conversations = Conversation.all
      flash.now[:danger] = "You didn't enter any keyword"
    else
      if get_keyword_count(keyword) == 1
        @search_result_and = conversation_part_search(keyword, AND)
        @search_result_or = @search_result_and
      else
        @search_result_and = conversation_part_search(keyword, AND)
        @search_result_or = conversation_part_search(keyword, OR)
      end
      @conversation_parts = @search_result_and.any? ? @search_result_and : @search_result_or
      @conversation_parts.with_highlights.each do |conversation_part, highlights|
        highlights_body = highlights[:sanitized_conversation_part_body]
        if get_matching_score(highlights_body, keyword) >= MINIMUM_MATCHING_SCORE
          conversation = conversation_part.conversation
          if @tag_filter == ALL
            @conversations << conversation unless @conversations.include?(conversation)
          else
            @conversations << conversation unless @conversations.include?(conversation) ||
                conversation.tags.include?(Tag.find_by_name(@tag_filter)) == false
          end
          if @conversation_highlights.keys.include? conversation
            @conversation_highlights[conversation] << highlights_body
          else
            @conversation_highlights[conversation] = [highlights_body]
          end
        end
      end
    end
    @conversations = @conversations.paginate(page: params[:page], per_page: 10)
    @tags = Tag.all
    render 'conversations/index'
  end

  def index
    @conversations = Conversation.all
    @conversation_highlights = {}
    @conversations = @conversations.paginate(page: params[:page], per_page: 10)
    @tags = Tag.all
  end

  def show
    @conversation = Conversation.find(params[:id])

  end

  def get_conversation
    if conversations_params[:item][:type] == CONVERSATION
      conversation_id = conversations_params[:item][:id]
      @conversation = Conversation.new(conversation_id: conversation_id)
      @conversation.save
      conversation = get_conversation_from_intercom(@conversation.conversation_id)
      store_conversation_parts(conversation)
      store_tags(conversation)
      render status: 200, json: {
          message: "success"}.to_json
    else
      render status: 200, json: {
          message: "Webhook ignored"}.to_json

    end

  end

  def store_conversation_parts (conversation)
    begin
      conversation_message = conversation.conversation_message
      find_or_create_author(conversation.conversation_message.author.id, conversation.conversation_message)
      @conversation_part = ConversationPart.create(conversation: @conversation, author: @author, conversation_part_id: conversation_message.id, conversation_part_body:
          conversation_message.body, sanitized_conversation_part_body: Rails::Html::FullSanitizer.new.sanitize(conversation_message.body), creation_date: Time.at(conversation.created_at))
      conversation.conversation_parts.each {|conversation_part|
        if conversation_part.author.type != BOT && conversation_part.body.present? && !conversation_part.body.include?(APP)
          find_or_create_author(conversation_part.author.id, conversation_part)
          @conversation_part = ConversationPart.create(conversation: @conversation, author: @author, conversation_part_id: conversation_part.id, conversation_part_body:
              conversation_part.body, sanitized_conversation_part_body: Rails::Html::FullSanitizer.new.sanitize(conversation_part.body), creation_date: Time.at(conversation_part.created_at))
        end
      }
    rescue Exception => e
      puts e.to_s
    end
  end



  def store_tags (conversation)
    begin
      conversation.tags.each do |conversation_tag|
        if Tag.find_by_tag_id(conversation_tag.id).present?
          tag = Tag.find_by_tag_id(conversation_tag.id)
        else
          tag = Tag.create(tag_id: conversation_tag.id, name: conversation_tag.name)
        end
        tag.conversations << @conversation
      end
    rescue Exception => e
      puts e.to_s
    end
  end

  def get_conversation_from_intercom(conversation_id)
    return IntercomClient::Client::Intercom.conversations.find(id: conversation_id)
  end

  def author_exist?(author_id)
    Author.find_by_author_id(author_id).present?
  end

  def get_author_from_conversation_part(conversation_part)
    case conversation_part.author.type
      when ADMIN
        author_object(IntercomClient::Client::Intercom.admins.find(id: conversation_part.author.id))
      when USER
        author_object(IntercomClient::Client::Intercom.users.find(id: conversation_part.author.id))
      when LEAD
        author_object(IntercomClient::Client::Intercom.contacts.find(id: conversation_part.author.id))
    end
  end

  def author_object(author)
    if author.type == ADMIN
      return {:author_id => author.id, :author_type => author.type, :name => author.name, :image_url => author.avatar[IMAGE_URL]}
    else
      return {:author_id => author.id, :author_type => author.type, :name => author.name, :image_url => author.avatar.image_url}
    end
  end

  def find_or_create_author(author_id, conversation_part)
    if author_exist?(author_id)
      @author = Author.find_by_author_id(author_id)
    else
      author_obj = get_author_from_conversation_part(conversation_part)
      @author = Author.create(author_id: author_obj[:author_id], author_type: author_obj[:author_type], name: author_obj[:name], image_url: author_obj[:image_url])
    end
  end

  def remove_conjunctions_and_articles (keyword)
    conjunctions_and_articles_list = CONJUNCTIONS_AND_ARTICLES_LIST
    keyword_without_conjunctions_articles_list = keyword.downcase.split(" ") - conjunctions_and_articles_list
    keyword_without_conjunctions_articles = keyword_without_conjunctions_articles_list.join(" ")
    return keyword_without_conjunctions_articles
  end

  def conversation_part_search(keyword, operator)
    if operator == OR
      ConversationPart.search keyword, operator: operator, highlight: {tag: MARK_TAG}, misspellings: false,
                              fields: [:sanitized_conversation_part_body]
    else
      ConversationPart.search keyword, misspellings: false, highlight: {tag: MARK_TAG},
                              fields: [:sanitized_conversation_part_body]
    end

  end

  def get_keyword_count (keyword)
    keyword.split(" ").length
  end

  def get_matching_score(highlights_body, keyword)
    freqs = {}
    freqs.default = 0
    Nokogiri::HTML(highlights_body).css(NOKOGIRI_MARK).each {|mark| freqs[mark.content.stem] += 1}
    score = freqs.keys.length.to_f / get_keyword_count(keyword).to_f
  end


  def conversations_params
    params[:data]
  end

  def ping
    render plain: "OK"
  end

end
