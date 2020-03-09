## Weather
In order to use the weather you can follow documnetation from the following link

- **[Weather Forecast from Powershell](https://winaero.com/blog/get-weather-forecast-powershell/)**

## Common Commands to Pull Out Weather Information
To get the current weather in PowerShell, type or copy-paste the following command:
```
(curl http://wttr.in/?Q0 -UserAgent "curl" ).Content
```
![Image](https://winaero.com/blog/wp-content/uploads/2017/06/Windows-10-weather-in-powershell-768x181.png)

You can specify the desired location as follows:

```
(curl http://wttr.in/NewYork -UserAgent "curl" ).Content
```
![Image](https://winaero.com/blog/wp-content/uploads/2017/06/Windows-10-location-weather-in-powershell.png)

You can specify the country where you live when required. The syntax is as follows:
```
(curl http://wttr.in/"Madrid,Spain" -UserAgent "curl" ).Content
```
![Image](https://winaero.com/blog/wp-content/uploads/2017/06/Windows-10-country-weather-in-powershell.png)

The service is localized into several languages.
To change the forecast language, you can use the following syntax:
```
(curl wttr.in/Berlin?lang=de -UserAgent "curl" ).Content
(curl wttr.in/Moscow?lang=ru -UserAgent "curl" ).Content
```
![Image](https://winaero.com/blog/wp-content/uploads/2017/06/Windows-10-weather-in-PowerShell-translated-to-Russian.png)

## Checking Out Moon Phases
Wttr.in can be used to see the current Moon phase. Execute the following command:
```
(curl wttr.in/Moon -UserAgent "curl" ).Content
```
![Image](https://winaero.com/blog/wp-content/uploads/2017/06/Windows-10-moon-phase-in-PowerShell.png)
