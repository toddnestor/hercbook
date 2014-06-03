desc "Import avatars from a user's gravatar URL"
task :import_avatars => :environment do
  puts "Importing avatars from Gravatar"
  User.get_gravatars
  puts "\nAvatars updated"
end