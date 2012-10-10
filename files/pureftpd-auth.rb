#!/usr/bin/env ruby
## encoding: utf-8
#
# This script integrates wtih PureFTPD's external authentication API.
# Username and password are passed in via the script's environment.
# This script will access Tropo's API to validate the credentials and return
# the user's "home" directory on S3.
#
# @author Ben Klang <bklang@mojolingo.com>

# PureFTPD external auth documentation:
# http://download.pureftpd.org/pub/pure-ftpd/doc/README.Authentication-Modules
#
# Environment variables provided by PureFTPD:
# AUTHD_ACCOUNT
# AUTHD_PASSWORD
# AUTHD_LOCAL_IP
# AUTHD_LOCAL_PORT
# AUTHD_REMOTE_IP
# AUTHD_ENCRYPTED

require 'rubygems'
require 'httparty'

CUSTHOME = '/webhosting'
UID = 101
GID = 101

class User
  attr_reader :user_data

  include HTTParty

  def initialize(u,p)
    @user, @pass = u, p
  end

  def valid?
    authenticate unless @user_data
    !@user_data.nil?
  end

  def authenticate
    @user_data ||= User.get("http://127.0.0.1:8080/rest/v1/user",:basic_auth => {:username => @user, :password => @pass}).parsed_response
  end
end

u = User.new ENV['AUTHD_ACCOUNT'], ENV['AUTHD_PASSWORD']

# 0: user not found
# -1: user found but fatal auth error (wrong password or banned user)
# 1: user found and authenticated successfully
puts "auth_ok:#{u.valid? ? "1" : "0"}"

# Unix UID and GID. Shared for all users.
puts "uid:#{UID}"
puts "gid:#{GID}"

# The home directory. '/./' denotes the chroot point
# The empty string at the end provides the needed trailing slash
if u.valid?
puts "dir:#{File.join [CUSTHOME, u.user_data['id'], '.', ""]}"
end
# The required "end" token
puts "end"