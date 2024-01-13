city=$1
temperature=$2
weather_data=$3
humidity_data=$4
report_file="report.txt"
echo "Processing data for $city on $(date)"

# Generate a report and append details of weather
echo "Weather Report for $city" >> "$report_file"
echo "--------------------------" >> "$report_file"
echo "Date: $(date)" >> "$report_file"
echo "City: $city" >> "$report_file"
echo "Temperature: $temperature Celsius" >> "$report_file"
echo "Weather: $weather_data" >> "$report_file"
echo "Humidity: $humidity_data%" >> "$report_file"

# It Messages about outdoor activities based on temperature
if [ "$(echo "$temperature > 20" | bc)" -eq 1 ]; then
    echo "The temperature is good for outdoor activities!" >> "$report_file"
elif [ "$(echo "$temperature > 10" | bc)" -eq 1 ]; then
    echo "The temperature is suitable for moderate outdoor activities." >> "$report_file"
else
    echo "Consider indoor activities as the temperature is too cold" >> "$report_file"
fi

# It gives notifcation of completion
notify-send "Data Processing Complete" "Data for $city has been processed. Report generated."
