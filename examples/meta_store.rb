require 'decouplio'

class SomeAction < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
  end

  def step_one(**)
    false
  end

  def fail_one(**)
    ms.status = :step_one_failure
    ms.add_error(:something_went_wrong, 'Something went wrong')
  end
end

action = SomeAction.call

action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_one

# Context:


# Status: step_one_failure

# Errors:
#   :something_went_wrong => ["Something went wrong"]

action.ms.errors # =>
# {:something_went_wrong=>["Something went wrong"]}

action.ms.status # =>
# step_one_failure



# Custom meta store

class CustomMetaStore
  attr_accessor :status
  attr_reader :errors, :whatever

  def initialize
    @errors = {}
    @status = nil
    @whatever = []
  end

  def add_error(key, messages)
    @errors.store(
      key,
      (@errors[key] || []) + [messages].flatten
    )
  end

  def add_whatever(element)
    @whatever << element
  end

  def to_s
    <<~METASTORE
      Status: #{@status || 'NONE'}

      Errors:
        #{errors_string}

      Whatever:
        #{@whatever.inspect}
    METASTORE
  end

  private

  def errors_string
    return 'NONE' if @errors.empty?

    @errors.map do |k, v|
      "#{k.inspect} => #{v.inspect}"
    end.join("\n  ")
  end
end

class CustomMetaStoreAction < Decouplio::Action
  meta_store_class CustomMetaStore

  logic do
    step :add_meta_status
    step :add_meta_error
    step :add_whatever
  end

  def add_meta_status(**)
    ms.status = :custom_status
  end

  def add_meta_error(**)
    ms.add_error(:custom_error, 'Custom error')
  end

  def add_whatever(**)
    ms.add_whatever(42)
    ms.add_whatever('Whatever')
  end
end

result = CustomMetaStoreAction.call

result
# Result: success

# RailwayFlow:
#   add_meta_status -> add_meta_error -> add_whatever

# Context:


# Status: custom_status

# Errors:
#   :custom_error => ["Custom error"]

# Whatever:
#   [42, "Whatever"]
