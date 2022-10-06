#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    decorator WikidataIdsDecorator::Links

    def member_container
      noko.xpath("//table[.//th[contains(.,'Fonction')]]//tr[td]")
    end
  end

  class Member
    field :id do
      name_node.css('a/@wikidata').first
    end

    field :name do
      name_node.css('a').map(&:text).map(&:tidy).first
    end

    field :positionID do
    end

    field :position do
      tds[position_index].xpath('.//text()').map(&:text).map(&:tidy).reject(&:empty?)
    end

    field :startDate do
    end

    field :endDate do
    end

    private

    def tds
      noko.css('td')
    end

    def name_node
      tds[-2]
    end

    def position_index
      noko.xpath('preceding::tr[th][1]//th').index { |th| th.text.include? 'Fonction' }
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
