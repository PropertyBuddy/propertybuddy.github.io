npm install -g wellknown
cat data.json | jq -r .Result.GeometryWKT | wellknown > multipoint.geojson


http://resources.arcgis.com/en/help/arcgis-rest-api/index.html#//02r3000000w5000000

http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/CityPlan/Priority_Infrastructure_Plan/MapServer/28/query?where=&text=&objectIds=&time=&geometry=bbox%3D502832.6880900261%2C6961230.032633334%2C504609.36872672074%2C6961417.887175711&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelContains&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=true&f=json
