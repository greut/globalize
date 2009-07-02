require 'memcache'
require 'digest/md5'

module Globalize # :nodoc:
  class DbViewTranslatorMemcache < DbViewTranslator
    SERVERS = "localhost:11211"
    NAMESPACE = "globalize"

    def cache_count
    end

    def cache_reset
    end

    private

      def cache_fetch(key, language, idx, namespace = nil)
        k = cache_key(key, language, idx, namespace)
        begin
          @cache.get(k)
        rescue MemCache::MemCacheError
          initialize
          @cache.get(k)
        end
      end

      def cache_add(key, language, idx, translation, namespace = nil)
        k = cache_key(key, language, idx, namespace)
        begin
          @cache.add(k, translation)
        rescue MemCache::MemCacheError
          initialize
          @cache.add(k, translation)
        end
      end

      def invalidate_cache(key, language, idx, namespace = nil)
        k = cache_key(key, language, idx, namespace)
        begin
          @cache.delete(k, namespace)
        rescue MemCache::MemCacheError
          initialize
          @cache.add(k, translation)
        end
      end

      def cache_key(key, language, idx, namespace = nil)
        Digest::MD5.hexdigest([key, language.code, idx, namespace].compact.join(':'))
      end

      def cache_hit_ratio
      end

      def cache_clear
      end

      def initialize()
        @cache = MemCache.new(SERVERS, :namespace=>NAMESPACE)
      end
  end
end
