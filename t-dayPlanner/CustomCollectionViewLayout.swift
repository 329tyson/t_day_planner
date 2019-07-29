import UIKit
class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var layoutCache: [UICollectionViewLayoutAttributes]? = nil
    
    
    
    override func prepare() {
        
        super.prepare()
        
        
        
        let width = (collectionView?.bounds.size.width ?? 375) / 2 - 5
        
        
        
        // attribute 만드는 작업은 한번만 합니다.
        
        guard layoutCache == nil else { return }
        
        
        
        var attrsList: [UICollectionViewLayoutAttributes] = []
        
        for (index, image) in images.enumerated() {
            
            let isOdd = index % 2 == 0
            
            let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
            
            let ratio = image.size.height / image.size.width
            
            let height = width * ratio
            
            
            
            var frame = CGRect(x: isOdd ? 0 : width + 10, y: 0, width: width, height: height)
            
            if index > 1 {
                
                let upperImage = attrsList[index-2]
                
                frame.origin.y = upperImage.frame.origin.y + upperImage.frame.size.height + 10
                
            }
            
            attrs.frame = frame
            
            
            
            attrsList.append(attrs)
            
        }
        
        
        
        layoutCache = attrsList
        
    }
    
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let layoutCache = layoutCache else { return super.layoutAttributesForElements(in: rect) }
        
        
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        
        
        for attributes in layoutCache {
            
            if attributes.frame.intersects(rect) {
                
                layoutAttributes.append(attributes)
                
            }
            
        }
        
        
        
        return layoutAttributes
        
    }
    
}
