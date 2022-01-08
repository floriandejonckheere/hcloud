# frozen_string_literal: true

def sleep_until(resource)
  5.times do
    resource.reload

    result = yield resource

    puts "result = #{result}"

    return if result

    sleep 1
  end

  raise "Condition not fulfilled after 5 retries"
end

def sleep_until_unlocked(resource)
  sleep_until(resource) do |r|
    r.actions.map(&:status).all? { |s| s == "success" }
  end
end
