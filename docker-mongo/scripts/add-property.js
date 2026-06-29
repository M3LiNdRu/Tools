// Add a new property to all documents in the ShoppingCart collection
db.ShoppingCart.updateMany(
  {}, // Filter: empty object matches all documents
  {
    $set: {
      newProperty: "workshop",
      updatedAt: new Date()
    }
  }
);

// Print the number of documents updated
print("Updated " + db.ShoppingCart.countDocuments() + " documents");