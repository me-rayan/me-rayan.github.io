#!/usr/bin/env ruby
#
# Replace the provider of certification posts with its name in `_data/providers.yml`

Jekyll::Hooks.register :site, :post_read do |site|

  names = {}

  (site.data['providers'] || []).each do |provider|
    [provider['name'], *provider['aliases']].each do |key|
      names[key.to_s.strip.downcase] = provider['name']
    end
  end

  site.posts.docs.each do |post|
    certification = post.data['certification']
    next unless certification.is_a?(Hash) && certification['provider']

    written = certification['provider'].to_s
    name = names[written.strip.downcase]

    if name
      certification['provider'] = name
    else
      Jekyll.logger.warn 'Providers:', "'#{ written }' is not in _data/providers.yml (#{ post.relative_path })"
    end
  end

end
