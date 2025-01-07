class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id)
  end
  def create
    friend = User.find(params[:friend_id])
    current_user.send_friend_request(friend)
    redirect_to friendships_path(friend), notice: "Friend request sent!"
  end

  def update
    friend = User.find(params[:friend_id])
    current_user.accept_friend_request(friend)
    redirect_to friendships_path(friend), notice: "Friend request accepted!"
  end

  def destroy
    request = Friendship.find(params[:id])
    request.destroy
    redirect_to friendships_path, notice: "Friendship request Cancelled."
  end

  def send_friend_request
    friend = User.find(params[:id])

    if current_user == friend
      flash[:error] ="You can't send a friend request to yourself"
      redirect_to friendships_path and return
    end
    current_user.send_friend_request(friend)
    flash[:notice]="Friend request sent to #{friend.username}"
    redirect_to friendships_path
  end

  def remove_friend
    friend = User.find(params[:id])
    friendship = current_user.friendships.find_by(friend_id: friend.id)
    if friendship.nil?
      friendship = current_user.inverse_friendships.find_by(user_id: friend.id)
    end

    if friendship
      friendship.destroy
      flash[:notice] = "You are no longer friends with #{friend.username}"
    else
      flash[:error]= "You are not friends with #{friend.username}"
    end
    redirect_to friendships_path
  end


  def pending_requests
    @pending_requests = current_user.inverse_friendships.where(status: "pending")
  end

  def accept
    friendship = Friendship.find(params[:id])
    if friendship.update(status: "accepted")
      redirect_to pending_requests_friendships_path, notice: "Friend request accepted."
    else
      redirect_to pending_requests_friendships_path, alert: " Could not Accept Friend request."
    end
  end

  def reject
    friendship = Friendship.find(params[:id])
    if friendship.update(status: "rejected")
      redirect_to pending_requests_friendships_path, notice: "Friend request rejected."
    else
      redirect_to pending_requests_friendships_path, alert: " Could not Reject Friend request."
    end
  end
end
