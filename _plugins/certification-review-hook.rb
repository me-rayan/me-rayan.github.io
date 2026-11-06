#!/usr/bin/env ruby
#
# Take certification posts without a written review out of the site, so they get no page of their own,
# and pass them to the Certifications page through `site.data['unreviewed_certifications']`.
# A post has no written review when its `certification` block sets `review: pending` or `review: none`.
# Runs after the provider hook, so their provider names are already resolved.

Jekyll::Hooks.register :site, :post_read, priority: :low do |site|

  unreviewed = []

  site.posts.docs.reject! do |post|
    certification = post.data['certification']
    next false unless certification.is_a?(Hash) && %w[pending none].include?(certification['review'].to_s)

    unreviewed << post.data
    true
  end

  site.data['unreviewed_certifications'] = unreviewed

end
