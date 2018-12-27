class Api::PopulateConversationsController < ApplicationController

  def populate
    closed_conversations_list = get_closed_conversations_list
    conversation_counter = 0
    closed_conversations_list.each do |conversation_id|
      unless conversation_exist? (conversation_id)
        conversation = get_conversation_from_intercom(conversation_id)
        @conversation = Conversation.create(conversation_id: conversation_id)
        store_conversation_parts(conversation)
        store_tags(conversation)
        conversation_counter += 1
      end
    end
    render status: 200, json: {
        message: "DB populated successfully: " + conversation_counter.to_s + " conversations created"
    }
  end

  def get_closed_conversations_list
    conversations_list = []
    IntercomClient::Client::Intercom.conversations.find_all(type: 'admin', id: '1309091').each {|conversation|
      conversations_list << conversation.id unless conversation.open
      puts "actual list size is" + conversations_list.length.to_s
    }
    return conversations_list
  end

  def store_conversation_parts (conversation)
    begin
      conversation_message = conversation.conversation_message
      auth = find_or_create_author(conversation.conversation_message.author.id, conversation.conversation_message)
      puts auth.name
      @conversation_part = ConversationPart.create(conversation: @conversation, author: @author, conversation_part_id: conversation_message.id, conversation_part_body:
          conversation_message.body, sanitized_conversation_part_body: Rails::Html::FullSanitizer.new.sanitize(conversation_message.body), creation_date: Time.at(conversation.created_at))
      conversation.conversation_parts.each {|conversation_part|
        if conversation_part.author.type != Constants::BOT && conversation_part.body.present? && !conversation_part.body.include?(Constants::APP)
          find_or_create_author(conversation_part.author.id, conversation_part)
          @conversation_part = ConversationPart.create(conversation: @conversation, author: @author, conversation_part_id: conversation_part.id, conversation_part_body:
              conversation_part.body, sanitized_conversation_part_body: Rails::Html::FullSanitizer.new.sanitize(conversation_part.body), creation_date: Time.at(conversation_part.created_at))
        end
      }
    rescue Exception => e
      Rails.logger.info(e)
    end
  end

  def store_tags (conversation)

    begin
      conversation_tags = conversation.tags.each do |conversation_tag|
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
end

def author_exist?(author_id)
  Author.find_by_author_id(author_id).present?
end

def conversation_exist?(conversation_id)
  Conversation.find_by_conversation_id(conversation_id).present?
end

def get_author_from_conversation_part(conversation_part)
  case conversation_part.author.type
    when Constants::ADMIN
      author_object(IntercomClient::Client::Intercom.admins.find(id: conversation_part.author.id))
    when Constants::USER
      author_object(IntercomClient::Client::Intercom.users.find(id: conversation_part.author.id))
    when Constants::LEAD
      author_object(IntercomClient::Client::Intercom.contacts.find(id: conversation_part.author.id))
  end
end

def author_object(author)
  if author.type == Constants::ADMIN
    return {:author_id => author.id, :author_type => author.type, :name => author.name, :image_url => author.avatar[Constants::IMAGE_URL]}
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


