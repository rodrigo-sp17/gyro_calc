# Gyro Calc
Gyro Calc is a simple Flutter app to calculate errors from gyro and magnetic compasses according 
to Sun's position. It works by requiring minimum input by navigators while providing highly detailed outputs, 
making the most of modern astronomical algorithms and technology to reduce much of the table-checking still
present in the industry.

## Getting Started
Just get the APK file from release and install in your Android device. :)

## Usage
Usage is very self-explanatory.
The navigator has to input:
- Current date (default: today)
- Current time, on UTC time zone (default: now)
- Latitude and longitude degrees, in absolute values (default: present GPS position)
- Latitude and longitude minutes, in absolute values and with decimal seconds (default: present GPS position)
- Latitude and longitude signs (N-S, W-E)
- Measured Sun's gyro heading

Once CALCULATE is clicked, some general data will be already available.
To complete error calculation, it is necessary to input:
- Gyro heading
- Magnetic heading
- (Optional) Magnetic declination

The app will try to auto fetch the declination from the internet. If it can't be reached, it will need to be manually
inserted.

## License
[MIT](/LICENSE)