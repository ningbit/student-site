require_relative './student.rb'
require 'sinatra/base'

module StudentSite
  class App < Sinatra::Base
    get '/' do
      @students = Student.all
      erb :'students/list'
    end

    # Student.all.each do |obj|
    #   get "/students/#{obj.name.gsub(" ","").downcase}" do
    #     @student = obj
    #     erb :"students/student_layout"
    #   end
    # end

    get "/students/:id" do
      @student = Student.find(params[:id].to_i)
      erb :"students/student_layout", :layout => :"students/student_layout"
    end

    get "/students/new" do

      erb :"students/new_student"
    end

    post "/students" do
    end

    get '/students/:id/edit' do

      erb :"students/edit"
    end

    post '/students/1' do
    end

  end
end