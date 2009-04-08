namespace :sorteio do
  desc "Fetchs new tweets and stores them in the Tweet model."
  task :update => :environment do
    Tweet.process_new_tweets
  end

  desc "Lists all participants."
  task :list => :environment do
    Tweet.list_all_users
  end

  desc "Deletes all tweets from the Tweet model."
  task :reset => :environment do
    Tweet.delete_all_tweets
  end
end
