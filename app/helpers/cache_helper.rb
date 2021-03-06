module CacheHelper
  def ccm_cache(key, options={}, &block)
    cache key, ccm_cache_options(options), &block
  end

  def ccm_cache_options(options={})
    options.reverse_merge! expires_in: 1.minute, race_condition_ttl: 10

    if competition_id = options.delete(:competition_id)
      begin
        options[:expires_in] = 1.week if $redis.sismember("past_competition_ids", competition_id)
      rescue Redis::CannotConnectError => e
        ExceptionNotifier.notify_exception(e)
      end
    end

    options
  end
end
