---
layout: default
title: With service step
permalink: /octo_as_service_step/
parent: Octo
nav_order: 5
---

Octo with service step

```ruby
class AssignMessage
  def self.call(ctx, ms, message:)
    ctx[:message] = message
  end
end

class OctoServiceStep < Decouplio::Action
  logic do
    octo :octo_name, ctx_key: :octo_key do
      on :octo_key1, AssignMessage, message: 'Octo key 1', on_success: :PASS
      on :octo_key2, AssignMessage, message: 'Octo key 2', on_success: :PASS
    end
  end
end

puts OctoServiceStep.call(octo_key: :octo_key1) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key1 -> AssignMessage
# Context:
#   :octo_key => :octo_key1
#   :message => "Octo key 1"
# Status: NONE
# Errors:
#   NONE

puts OctoServiceStep.call(octo_key: :octo_key2) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key2 -> AssignMessage
# Context:
#   :octo_key => :octo_key2
#   :message => "Octo key 2"
# Status: NONE
# Errors:
#   NONE
```
