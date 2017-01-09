request = require 'request'
fs = require 'fs'

#response from api/versionedApiResponse/MinimalTaxonomies
minimalTaxonomiesResponse = require './minimalTaxonomiesResponse.coffee'

imageArray = []

parseText = (response) ->
  response.forEach( (object) ->
    object.taxons.forEach( (taxon) ->
      taxon.products.forEach( (product) ->
        for image of product.flat_images_by_color
          imageArray.push product.flat_images_by_color[image] + "?h=250"
      )
    )
  )

parseText(minimalTaxonomiesResponse)

loopFunc = (image) ->
  temp = image.slice(41, image.length-6)
  startingPoint = temp.indexOf("/")+1
  name = temp.slice(startingPoint)
  req = request.get(image).on('error', (err) -> console.log('error: ',err))
  req.pipe( fs.createWriteStream('images/'+name) )



imageArrays = {}
arrayCounter = 0
imageCounter = 0

imageArrays[0] = imageArray.slice(0,500)
imageArrays[1] = imageArray.slice(500,1000)
imageArrays[2] = imageArray.slice(1000,1500)
imageArrays[3] = imageArray.slice(1500,2000)
imageArrays[4] = imageArray.slice(2000,2500)
imageArrays[5] = imageArray.slice(2500,3000)
imageArrays[6] = imageArray.slice(3000,3500)
imageArrays[7] = imageArray.slice(3500,4000)
imageArrays[8] = imageArray.slice(4000)

requestAndParseImages = (arrayCounter) ->
  if arrayCounter >= 9
    #clears set interval
    clearInterval(intervalId)
  else
    for imageCount in imageArrays[arrayCounter]
      console.log(imageCounter++)
      loopFunc(imageCount)

#imgix times out if you make more than ~1k request at a time
intervalId = setInterval () ->
  requestAndParseImages(arrayCounter++)
, 15000


