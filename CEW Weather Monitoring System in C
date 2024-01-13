#include <stdio.h>
#include <curl/curl.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

struct WeatherData {
    double temperature;
    char weather[50];
    double humidity;
};

// Callback function to handle the HTTP response
static size_t write_callback(char *ptr, size_t size, size_t nmemb, void *userdata) {
    size_t total_size = size * nmemb;
    struct WeatherData *data = (struct WeatherData *)userdata;
    // Keys to identify data in the JSON response
    const char *temp_key = "\"temp_c\":";
    const char *weather_key = "\"text\":\"";
    const char *humidity_key = "\"humidity\":";
    // Extract data from the JSON response
    char *temp_ptr = strstr(ptr, temp_key);
    char *weather_ptr = strstr(ptr, weather_key);
    char *humidity_ptr = strstr(ptr, humidity_key);
    if (temp_ptr && weather_ptr && humidity_ptr) {
        sscanf(temp_ptr + strlen(temp_key), "%lf", &data->temperature);
        sscanf(weather_ptr + strlen(weather_key), "%49[^\",]", data->weather);
        sscanf(humidity_ptr + strlen(humidity_key), "%lf", &data->humidity);
    }
    return total_size;
}

void retrieveEnvironmentalData(const char *city) {
    CURL *curl;
    CURLcode res;
    struct WeatherData weather;
    curl = curl_easy_init();
    if (curl) {
        const char *api_key = "760e150f60374f68a0e185511231912";
        char url[256];
        snprintf(url, sizeof(url), "http://api.weatherapi.com/v1/current.json?key=%s&q=%s&aqi=yes", api_key, city);

        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &weather);

        res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        }
        else {
            printf("City Name: %s\n", city);
            printf("Temperature: %.2f Celsius\n", weather.temperature);
            printf("Weather: %s\n", weather.weather);
            printf("Humidity: %.2f%%\n", weather.humidity);
            // Creating filenames with timestamp
            time_t current_time;
            char timestamp[50];
            current_time = time(NULL);
            strftime(timestamp, sizeof(timestamp), "%Y%m%d%H%M%S", localtime(&current_time));
            char raw_data_filename[100];
            char processed_data_filename[100];
            snprintf(raw_data_filename, sizeof(raw_data_filename), "raw_data_%s.txt", timestamp);
            snprintf(processed_data_filename, sizeof(processed_data_filename), "processed_data_%s.txt", timestamp);

            //Opening files for raw_data and process_data
            FILE *raw_data_file = fopen(raw_data_filename, "w");
            FILE *processed_data_file = fopen(processed_data_filename, "w");

            if (raw_data_file == NULL || processed_data_file == NULL) {
                fprintf(stderr, "Error opening files.\n");
                return;
            }
            fprintf(raw_data_file, "City Name: %s\n", city);
            fprintf(raw_data_file, "Temperature: %.2f Celsius\n", weather.temperature);
            fprintf(raw_data_file, "Weather: %s\n", weather.weather);
            fprintf(raw_data_file, "Humidity: %.2f%%\n", weather.humidity);
            // For demonstration purposes, let's say processed data is the same as raw data
            fprintf(processed_data_file, "City Name: %s\n", city);
            fprintf(processed_data_file, "Temperature: %.2f Celsius\n", weather.temperature);
            fprintf(processed_data_file, "Weather: %s\n", weather.weather);
            fprintf(processed_data_file, "Humidity: %.2f%%\n", weather.humidity);

            // CIf else conditions for alert
            if (weather.temperature > 25.0) {
                printf("High temperature alert!\n");
                printf("Temperature exceeds 25.0 Celsius\n");
                system("notify-send 'High Temperature Alert!' 'Temperature exceeds 25.0 Celsius'");
            }
            else if (weather.temperature < 15.0) {
                printf("Low temperature alert!\n");
                printf("Temperature is below 15.0 Celsius\n");
                system("notify-send 'Low Temperature Alert!' 'Temperature is below 15.0 Celsius'");
            }
            else {
                printf("Normal temperature range.\n");
            }
            printf("Environmental data retrieved and stored.\n");
            fclose(raw_data_file);
            fclose(processed_data_file);
            //This is code for shell script integration
            char shell_command[256];
            snprintf(shell_command, sizeof(shell_command), "./process_data.sh %s", city);
            system(shell_command);
        }
        curl_easy_cleanup(curl);
    }
}

int main() {
    const char city[] = "Karachi";
    retrieveEnvironmentalData(city);
    return 0;
}
