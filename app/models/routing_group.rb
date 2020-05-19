# frozen_string_literal: true

# == Schema Information
#
# Table name: routing_groups
#
#  id   :integer          not null, primary key
#  name :string           not null
#

class RoutingGroup < ActiveRecord::Base
  before_destroy :check_deps

  has_and_belongs_to_many :routing_plans, class_name: 'Routing::RoutingPlan',
                                          join_table: 'class4.routing_plan_groups'

  has_many :dialpeers, dependent: :destroy

  has_paper_trail class_name: 'AuditLogItem'

  validates :name, presence: true
  validates :name, uniqueness: { allow_blank: false }

  def display_name
    "#{name} | #{id}"
  end

  private

  def check_deps
    if routing_plans.count > 0
      errors.add(:base, 'Routing Group used in Routing Plan configuration. You must unlink it first')
      throw(:abort)
    end
  end
end
