require 'rmagick'
require 'chroma'
require 'pry'
require 'benchmark'

time = Benchmark.measure do
  file, *signatures = ARGV
  filename = file.split('/').last

  images = Magick::ImageList.new(file)

  page = 1

  coordinates = []

  images.each do |image|
    page_data = {
      page: page,
      signatures: signatures.map { |option| { color: option, coordinates: [] } }
    }

    # image.write("images/#{filename}.#{page}.png")

    image.each_pixel do |pixel, row, col|
      rgb_combination = [pixel.red / 257, pixel.green / 257, pixel.blue / 257]
      hex = "rgb(#{rgb_combination.join(', ')})".paint.to_hex

      page_data[:signatures].select { |data| data[:color] == hex }.first[:coordinates] << "#{row}, #{col}" if signatures.include?(hex)
    end

    coordinates << page_data

    page += 1

    image.destroy!
  end
end

puts time
