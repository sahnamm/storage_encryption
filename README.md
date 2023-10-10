# storage_encryption
This is a rough analysis between several options to save data to local storage using encryption. [[article]](https://medium.com/@sahnamm/encrypt-local-storage-in-flutter-mobile-ef2e4d40e0be)

Written in Flutter 3.13.1 and Dart 3.1.0

## Save as string

There is no limitation size or line to save the string format.

Eg. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis mollis pretium est, id placerat dolor rhoncus non. Vestibulum et nunc sem. Nulla facilisi. Sed fermentum eget nulla ut iaculis. Proin fermentum justo neque, faucibus consectetur massa porta nec. Suspendisse non sapien id neque fringilla faucibus. Sed quis nulla sed nunc dictum sollicitudin in dapibus ex. Proin rhoncus justo metus, a euismod nisl interdum nec. In sagittis tincidunt porta. Mauris dictum aliquet sem, eu accumsan diam vestibulum at. 

## Save as boolean

Only accept false or true

Eg. false

## Save as integer

Save any number that fits in integer size

Eg. 18374723

## Save as list string

Separated by commas

Eg. one, two, three, four, five, apple, mango, strawberry, bear, panda, cat

## Save as object

Object cannot be dynamic and already predefined, you can update the value instead. Feel free to create your own object.

Eg.
{
   "stringValue":"string",
   "boolValue": boolean,
   "intValue": int
}
