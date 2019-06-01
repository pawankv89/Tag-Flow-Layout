# Tag Flow Layout

=========

## Tag Flow Layout in Swift 5.

------------
Added Some screens here.

![](https://github.com/pawankv89/Tag-Flow-Layout/blob/master/images/screen_1.png)
![](https://github.com/pawankv89/Tag-Flow-Layout/blob/master/images/screen_2.png)
![](https://github.com/pawankv89/Tag-Flow-Layout/blob/master/images/screen_3.png)

## Usage
------------

####  Flow Layout

```swift

import Foundation
import UIKit


/*
class FlowLayout: UICollectionViewFlowLayout {

override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
let layoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
guard scrollDirection == .vertical else { return layoutAttributes }

// Filter attributes to compute only cell attributes
let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })

// Group cell attributes by row (cells with same vertical center) and loop on those groups
for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
// Set the initial left inset
var leftInset = sectionInset.left

// Loop on cells to adjust each cell's origin and prepare leftInset for the next cell
for attribute in attributes {
attribute.frame.origin.x = leftInset
leftInset = attribute.frame.maxX + minimumInteritemSpacing
}
}

return layoutAttributes
}
}
*/

public enum Alignment {
case justified
case left
case center
case right
}

public class FlowLayout: UICollectionViewFlowLayout {

typealias AlignType = (lastRow: Int, lastMargin: CGFloat)

var align: Alignment = .right

override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
guard let collectionView = collectionView else { return nil }
guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }

let shifFrame: ((UICollectionViewLayoutAttributes) -> Void) = { [unowned self] layoutAttribute in
if layoutAttribute.frame.origin.x + layoutAttribute.frame.size.width > collectionView.bounds.size.width {
layoutAttribute.frame.size.width = collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right
}
}

var leftMargin = sectionInset.left
var maxY: CGFloat = -1.0
var alignData: [AlignType] = []

attributes.forEach { layoutAttribute in
switch align {
case .left, .center, .right:
if layoutAttribute.frame.origin.y >= maxY {
alignData.append((lastRow: layoutAttribute.indexPath.row, lastMargin: leftMargin - minimumInteritemSpacing))
leftMargin = sectionInset.left
}

shifFrame(layoutAttribute)

layoutAttribute.frame.origin.x = leftMargin

leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing

maxY = max(layoutAttribute.frame.maxY , maxY)
case .justified:
shifFrame(layoutAttribute)
}
}

align(attributes: attributes, alignData: alignData, leftMargin: leftMargin - minimumInteritemSpacing)

return attributes
}

private func align(attributes: [UICollectionViewLayoutAttributes], alignData: [AlignType], leftMargin: CGFloat) {
guard let collectionView = collectionView else { return }

switch align {
case .left, .justified:
break
case .center:
attributes.forEach { layoutAttribute in
if let data = alignData.filter({ $0.lastRow > layoutAttribute.indexPath.row }).first {
layoutAttribute.frame.origin.x += ((collectionView.bounds.size.width - data.lastMargin - sectionInset.right) / 2)
} else {
layoutAttribute.frame.origin.x += ((collectionView.bounds.size.width - leftMargin - sectionInset.right) / 2)
}
}
case .right:
attributes.forEach { layoutAttribute in
if let data = alignData.filter({ $0.lastRow > layoutAttribute.indexPath.row }).first {
layoutAttribute.frame.origin.x += (collectionView.bounds.size.width - data.lastMargin - sectionInset.right)
} else {
layoutAttribute.frame.origin.x += (collectionView.bounds.size.width - leftMargin - sectionInset.right)
}
}
}
}
}


```

#### Custom CollectonVew Cell

```swift

import UIKit

class TagCell: UICollectionViewCell {

@IBOutlet weak var tagName: UILabel!

override func awakeFromNib() {
super.awakeFromNib()
// Initialization code

//Must Number of Line set 1 always when use iOS Version 10.0 and Above
self.tagName.numberOfLines = 1
self.tagName.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
}

}


```



#### How to use 

```swift

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

let TAGS = ["Tech", "Design", "Humor", "Travel", "Music", "Writing", "Social Media", "Life", "Education", "Edtech", "Education Reform", "Photography", "Startup", "Poetry", "Women In Tech", "Female Founders", "Business", "Fiction", "Love", "Food", "Sports"]

@IBOutlet weak var collectionView: UICollectionView!

@IBOutlet weak var flowLayout: FlowLayout!

var sizingCell: TagCell?

override func viewDidLoad() {
super.viewDidLoad()

let cellNib = UINib(nibName: "TagCell", bundle: nil)
self.collectionView.register(cellNib, forCellWithReuseIdentifier: "TagCell")
self.collectionView.backgroundColor = UIColor.clear

self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?

self.collectionView.delegate = self
self.collectionView.dataSource = self

flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
flowLayout.align = Alignment.left
self.collectionView.collectionViewLayout = flowLayout
self.collectionView.reloadData()
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

self.configureCell(cell: self.sizingCell!, forIndexPath: indexPath)
return self.sizingCell!.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
}


func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
return TAGS.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagCell
self.configureCell(cell: cell, forIndexPath: indexPath)
return cell
}

func configureCell(cell: TagCell, forIndexPath indexPath: IndexPath) {
let tag = TAGS[indexPath.row]
cell.tagName.text = tag

//Cell Corner Radius
cell.layer.borderColor = UIColor.lightGray.cgColor
cell.layer.borderWidth = 1
cell.layer.cornerRadius = cell.frame.size.height / 2
//cell.backgroundColor = UIColor.lightGray

}


func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

print("didSelectItemAt:-\(indexPath.row)")

}

}



```



## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Change-log

A brief summary of each this release can be found in the [CHANGELOG](CHANGELOG.mdown). 
