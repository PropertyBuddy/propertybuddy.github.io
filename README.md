npm install -g wellknown
cat data.json | jq -r .Result.GeometryWKT | wellknown > multipoint.geojson


http://resources.arcgis.com/en/help/arcgis-rest-api/index.html#//02r3000000w5000000

http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/
http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/CityPlan/Priority_Infrastructure_Plan/MapServer/44

http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/CityPlan/Priority_Infrastructure_Plan/MapServer/28/query?where=&text=&objectIds=&time=&geometry=bbox%3D502832.6880900261%2C6961230.032633334%2C504609.36872672074%2C6961417.887175711&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelContains&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=true&f=json


big bbox


"http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/CityPlan/Priority_Infrastructure_Plan/MapServer/44/query?where=&text=&objectIds=&time=&geometry=bbox%3D502485%2C6957944%2C505568%2C6960226%0D%0A&geometryType=esriGeometryEnvelope&inSR=28356&spatialRel=esriSpatialRelContains&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=json"


http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/CityPlan/Contours/MapServer
http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/CityPlan/Base/MapServer

Sewerage
http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/CityPlan/Priority_Infrastructure_Plan/MapServer/28

Storm
http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/CityPlan/Priority_Infrastructure_Plan/MapServer/44

# Get Suburb

```

SUBURB="McDowall"
LAYERS="28 44"

ESCAPED=`echo $SUBURB | replace " " "%20"`
ogr2ogr -f GeoJSON "$SUBURB.json" "http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/CityPlan/Search/MapServer/2/query?where=SUBURB_NAME+%3D+%27$ESCAPED%27&text=&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=json" OGRGeoJSON

BOUNDING_BOX=`ogrinfo -so -al -ro "$SUBURB.json" | grep Extent | replace "Extent: " "" | replace "(" "" | replace ")" "" | replace " - " ", " | replace ", " ","`

for LAYER in $LAYERS
do
  ogr2ogr -f GeoJSON "${SUBURB}_${LAYER}.json" "http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/CityPlan/Priority_Infrastructure_Plan/MapServer/$LAYER/query?where=&text=&objectIds=&time=&geometry=bbox=$BOUNDING_BOX&geometryType=esriGeometryEnvelope&inSR=28356&outSR=4326&spatialRel=esriSpatialRelContains&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=json" OGRGeoJSON
done

geojson-merge *28.json > Sewerage.geojson
geojson-merge *44.json > Stormwater.geojson

```

## Contours
ogr2ogr -f GeoJSON "${SUBURB}_Contours.json" "http://cityplan2014maps.brisbane.qld.gov.au/arcgis/rest/services/CityPlan/Contours/MapServer/0/query?where=&text=&objectIds=&time=&geometry=bbox=$BOUNDING_BOX&geometryType=esriGeometryEnvelope&inSR=28356&spatialRel=esriSpatialRelContains&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=json" OGRGeoJSON
