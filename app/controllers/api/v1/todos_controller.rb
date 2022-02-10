# frozen_string_literal: true

class Api::V1::TodosController < ApplicationController
  before_action :authorize
  before_action :find_todo, except: %i[index create]

  def index
    render json: { data: @current_user.todos }
  end

  def show
    render json: { data: @todo }
  end

  def create
    todo = Todo.create title: params['title'], user_id: @current_user.id

    if todo.errors.messages.empty?
      render json: { data: todo }, status: :created
    else
      render json: { error: { message: todo.errors.messages } },
             status: :unprocessable_entity
    end
  end

  def update
    @todo.update title: params['title']

    if @todo.errors.messages.empty?
      render json: { data: @todo }
    else
      render json: { error: { message: @todo.errors.messages } },
             status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
    render json: { data: params['id'].to_i }
  end

  private

  def find_todo
    @todo = Todo.find_by! id: params['id']
  rescue ActiveRecord::RecordNotFound
    render json: { error: { message: 'Not found' } }, status: :not_found
  end
end
