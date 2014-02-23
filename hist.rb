require 'csv'

data = CSV.read('./hist-data.csv')
data = data[0]
data.map! { |value| value.to_i }
data.sort!
min = data.min
max = data.max
step = (max - min)/10.0
hist = [0] # or hist = Array.new(1, 0)

current_range = min + step
current_range_index = 0
data.each_with_index do |value|
  if value <= current_range
    hist[current_range_index] += 1
  else
    current_range += step
    current_range_index += 1
    hist[current_range_index] = 1
  end
end

hist.each_with_index do |freq, key|
  puts "#{min+step*key}-#{min+step*(key+1)}: #{freq.to_i}"
end

d3_output = <<D3OUTPUT

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>D3 Demo: 5-div bar chart</title>
		<script type="text/javascript" src="d3/d3.v3.js"></script>
		<style type="text/css">
		
			div.bar {
				display: inline-block;
				width: 20px;
				height: 75px;	/* Gets overriden by D3-assigned height below */
				margin-right: 2px;
				background-color: teal;
			}
		
		</style>
	</head>
	<body>
		<script type="text/javascript">
		
			var dataset = #{hist.to_s};
			
			d3.select("body").selectAll("div")
				.data(dataset)
				.enter()
				.append("div")
				.attr("class", "bar")
				.style("height", function(d) {
					var barHeight = d * 5;
					return barHeight + "px";
				});
			
		</script>
	</body>
</html>
D3OUTPUT

output = File.open("index.html", "w")
output << d3_output
output.close
