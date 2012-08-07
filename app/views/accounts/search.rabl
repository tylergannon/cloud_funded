collection @members, object_root: false
node(:full_name) {|member| member.full_name}
node(:partial) {|member| "<div class='search_result'>#{member.full_name}<img src='#{member.profile_pic}' /></div>"}
node(:id) {|member| member.id.to_s}