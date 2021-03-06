# == Schema Information
#
# Table name: class4.routing_tag_detection_rules
#
#  id               :integer          not null, primary key
#  dst_area_id      :integer
#  src_area_id      :integer
#  tag_action_id    :integer
#  tag_action_value :integer          default([]), not null, is an Array
#  routing_tag_ids  :integer          default([]), not null, is an Array
#

class Routing::RoutingTagDetectionRule < Yeti::ActiveRecord
  has_paper_trail class_name: 'AuditLogItem'
  self.table_name='class4.routing_tag_detection_rules'

  validates_with TagActionValueValidator
  validates_with RoutingTagIdsValidator

  belongs_to :src_area, class_name: Routing::Area, foreign_key: :src_area_id
  belongs_to :dst_area, class_name: Routing::Area, foreign_key: :dst_area_id
  belongs_to :tag_action, class_name: 'Routing::TagAction'

  array_belongs_to :routing_tags, class_name: 'Routing::RoutingTag', foreign_key: :routing_tag_ids
  array_belongs_to :tag_action_values, class_name: 'Routing::RoutingTag', foreign_key: :tag_action_value

  def display_name
    "#{self.id}"
  end

end
