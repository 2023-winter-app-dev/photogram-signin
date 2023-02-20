class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")

    user.password = params["input_password"]

    user.password_confirmation = params["input_password_confirmation"]

    save_status = user.save
    if save_status == true
      session.store(:user_id, user.id)
      redirect_to("/users/#{user.username}", { :notice => "Welcome, " + user.username + "!" })
    else
      redirect_to("/user_sign_up", { :alert => user.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)

    user.username = params.fetch("input_username")

    user.save

    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

  def signup
    render({ :template => "users/signup_form.html.erb" })
  end

  def signout
    reset_session
    redirect_to("/", { :notice => "See ya later!" })
  end

  def signin
    render({ :template => "users/signin_form.html.erb" })
  end

  def authenticate
    user_name = params["input_username"]
    user_password = params["input_password"]
    db_user = User.where({ :username => user_name })[0]
    if db_user == nil
      redirect("/user_sign_in", { :alert => "No one by that name 'round these parts" })
    else
      if db_user.authenticate(user_password)
        redirect_to("/", { :notice => "Welcome back, " + user_name + "!" })
      else
        redirect_to("/user_sign_in", { :alert => "Password does not match user account" })
      end
    end
  end
end
