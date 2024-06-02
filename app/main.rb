require 'zlib'

command = ARGV[0]
case command
when "init"
  Dir.mkdir(".git")
  Dir.mkdir(".git/objects")
  Dir.mkdir(".git/refs")
  File.write(".git/HEAD", "ref: refs/heads/main\n")
  puts "Initialized git directory"
when "cat-file"
  object = ARGV[2]
  directory, filename = object[0..1], object[2..-1]
  path = ".git/objects/#{directory}/#{filename}"
  compressed = File.read(path)
  uncompressed = Zlib::Inflate.inflate(compressed)
  content = uncompressed.split("\0", 2)[1]
  print content
else
  raise RuntimeError.new("Unknown command #{command}")
end
