npm install -g wellknown
cat data.json | jq -r .Result.GeometryWKT | wellknown > multipoint.geojson
