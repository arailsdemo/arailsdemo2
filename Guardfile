# class Guard::Timer
#   def times
#     @times ||= {}
#   end
#
#   def call(guard_class, event, *args)
#     event.to_s =~ /(.*)_(begin|end)/
#     times[[guard_class, $1, $2]] = Time.now
#     puts "#{guard_class} received these args: #{args} for #{event}"
#
#     if $2 == 'end'
#       time = @times[[guard_class, $1, 'end']] - @times[[guard_class, $1, 'begin']]
#       puts "#{guard_class} took #{time} seconds to run"
#     end
#   end
# end

#guard 'spork', :cucumber => false, :rspec_env => { 'RAILS_ENV' => 'test' } do
guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'cucumber' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
  watch(%r{^spec/factories/.+\.rb})
end

guard 'rspec', :bundler => false, :all_on_start => false do
  watch('spec/spec_helper.rb')                       { "spec" }
  watch('config/routes.rb')                          { "spec/routing" }
  watch('app/controllers/application_controller.rb') { "spec/controllers" }
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^app/(.+)\.rb})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
end

# Guard 'cucumber' do
#  watch(%r{^features/.+\.feature})
#  watch(%r{^features/support/.+})          { 'features' }
#  watch(%r{^features/step_definitions/(.+)_steps\.rb}) { |m| Dir[File.join("**/*#{m[1]}.feature")][0] || 'features' }
#
#  watch(%r{^external_features/.+\.feature})
#  watch(%r{^external_features/support/.+})          { 'external_features' }
#  watch(%r{^external_features/step_definitions/.+}) { 'external_features' }

#  callback(Timer.new, [:run_on_change_begin, :run_on_change_end])

#  watch(%r{^features/support/.+})          { 'external_features' }

#  callback(:run_on_change_begin) do |klass, event, *args|
#    path = args.flatten!.first
#    if path =~ /external_features/
#      UI.info "#{klass}'s callback :#{event} running for: #{args}", :reset => true
#      system("cucumber --format Guard::Cucumber::NotificationFormatter --out /dev/null #{args.first}")
#    end
#  end
# end
