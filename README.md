#CarlEnergy

Client: Martha Larson

Team: Caleb Braun, Hami Abdi, Simon Orlovsky

CarlEnergy is a iOS application that produces the reports about Carleton building energy usage and Carleton energy production. This application allows you to create reports with multiple buildings or just a single building.

##Build Instructions
```
git clone https://github.com/simonorlovsky/Energy.git
Open Energy.xcodeproj
```

##Future Developers
Incomplete features:
(Note that the production is not always 0 percent. If it isn't windy it will be 0)

###Front End
- Search for building comparison mode
- Segmented Control implementation

###Back End
The Production Side of the app as of right now has an infrastructure that allows for maximum flexibility — it allows for all 2^4 permutations of Turbine 1 data, Turbine 2 production and speed data, and SolarPV data. In addition, the production side enables various time period database calls, and the Data Retriever class itself enables multiple ways to request data, which allows for most convenience depending on various needs. There was not enough time to actually implement all of the components of the production side, but the methods, classes, and constants/variables allow for such future implementation. Moreover, our approach to requesting data is using NSURLSession which in itself allows for maximum flexibility!
