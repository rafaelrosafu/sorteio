class Tweet < ActiveRecord::Base
  Hashtag = "ri_urubatan"
  Tweets_Per_Query = 50
  Tweets_Per_Run = 1000

  after_validation :print_save_errors

  validates_presence_of :text, :message => "There's no text"
  validates_presence_of :user, :message => "There's no user"
  validates_uniqueness_of :user, :message => "This user has already voted"

  def self.process_new_tweets
    puts "process_new_tweets(): Started processing of new tweets"
 
    tweets = fetch_new_tweets
    puts "process_new_tweets(): No new tweets for now." and return unless tweets.size > 0
 
    tweets = sort_tweets_results(tweets)
 
    tweets.each do |tweet|
      puts "process_new_tweets(): Adding new tweet..."
      add_new_tweet(tweet)
 
      puts "process_new_tweets(): Last tweet processed is id = #{tweet.id.to_s}"
      # set_last_tweet_processed(tweet.id)
    end
 
    puts "process_new_tweets(): Finished processing of new tweets."
  end

  def self.fetch_new_tweets
    i = 1
    tweets_all = []
    begin
      last_id = last_tweet_processed

      puts "fetch_new_tweets(): Fetching tweets from Twitter API, page #{i.to_s}... (Hashtag: #{Hashtag}, last_id: #{last_id.to_s})"
      tweets = Twitter::Search.new.hashed(Hashtag).since(last_id).per_page(Tweets_Per_Query).page(i).fetch.results
      puts "fetch_new_tweets(): Fetched #{tweets.size} tweets" unless tweets.nil?

      tweets.each {|t| tweets_all.push(t) }
      i += 1
    end while tweets.size == Tweets_Per_Query && tweets_all.size <= Tweets_Per_Run

    pages = i-1
    puts "fetch_new_tweets(): Finished fetching tweets from Twitter API: fetched #{tweets_all.size} tweets and #{pages.to_s} pages."

    tweets_all
  end

  def self.add_new_tweet(tweet)
    new_tweet = new
    new_tweet.data_fields = tweet
    new_tweet.save
  end

  def self.sort_tweets_results(tweets)
    tweets.sort_by {|t| t.id}
  end

  def data_fields=(data)
    self.id = data['id'].to_i
    self.user = data['from_user']
    self.user_id = data['from_user_id']
    self.text = data['text']
    self.user_image = data['profile_image_url']
    self.posted_at = data['created_at']
  end

private

  def self.last_tweet_processed
    last.nil? ?  0 : last.id
    # Batch.last_tweet_processed
  end

  #def self.set_last_tweet_processed(id)
  #  Batch.set_last_tweet_processed(id)
  #end

  def print_save_errors
    if errors.count > 0
      puts "\tError(s) when trying to validate:"
 
      output = ""
      errors.each do |attr,msg|
        output << "\t#{attr} => #{msg}\n"
      end
      puts output
    end
  end
end
