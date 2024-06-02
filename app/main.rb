require 'zlib'
require 'digest/sha1'

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
when "hash-object"
  file = ARGV[2]
  uncompressed_data = File.read(file)
  data = "blob #{uncompressed_data.bytesize}\0" + uncompressed_data
  sha1 = Digest::SHA1.hexdigest(data)
  puts sha1
  compressed_data = Zlib::Deflate.deflate(data)
  directory, filename = sha1[0..1], sha1[2..-1]
  path = ".git/objects/#{directory}"
  Dir.mkdir(path) unless Dir.exist?(path)
  file_path = "#{path}/#{filename}"
  File.write(file_path, compressed_data)
else
  raise RuntimeError.new("Unknown command #{command}")
end
