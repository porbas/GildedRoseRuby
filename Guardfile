guard :minitest, include: %w(lib test) do
  watch(%r{(.+)\.rb$})     { |m| "test/#{m[1]}_test.rb" }
  watch(%r{.+_test\.rb$})
end
