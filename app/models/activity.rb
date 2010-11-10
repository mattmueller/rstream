class Activity < ActiveRecord::Base
  serialize :metadata, Hash

  validates_presence_of :title
  validates_presence_of :type

  def self.data_for_graph(type=nil)
    @data = []
    @labels = []
    @graph_info = []
    if type.nil?
      dates = Activity.get_all_months
    else
      dates = Activity.get_all_months
    end
    dates.each_with_index do |date, index|
      if dates[index + 1].nil?
        if type.nil?
          @data << Activity.count(:conditions => ["created_at > ?", date])
        else
          @data << Activity.count(:conditions => ["created_at > ? and type = ?", date, type])
        end
      else
        if type.nil?
          @data << Activity.count(:conditions => ["created_at > ? and created_at < ?", date, dates[index + 1]])
        else
          @data << Activity.count(:conditions => ["created_at > ? and created_at < ? and type = ?", date, dates[index + 1], type])
        end
      end
    end
    step = dates.count / 3
    [0, (step * 2) - 1, (step * 3)].each do |singlestep|
      @labels << "#{dates[singlestep]}".to_time.to_formatted_s(:short_date)
    end
    @graph_info = [@data, @labels]
  end

  def self.get_all_months(start=Activity.minimum('created_at'), finish=Date.today)
    @dates = []
    (start.year..finish.year).each do |y|
       mo_start = (start.year == y) ? start.month : 1
       mo_end = (finish.year == y) ? finish.month : 12
       (mo_start..mo_end).each do |m|  
           @dates << "#{y}-#{m}-01"
       end
    end
    return @dates
  end

  def self.build_graph_url(type=nil)
    if type.nil?
      @data = Activity.data_for_graph
    else
      @data = Activity.data_for_graph(type)
    end
    @url = Gchart.sparkline(:data => @data[0], :height => 36, :width => 280, :line_colors => '6F7936')
  end
          
end
