//
//  PDFView.swift
//  PDFGreat
//
//  Created by MIkkyMouse on 10.07.2020.
//  Copyright © 2020 Ivan Sosnovich. All rights reserved.
//

import UIKit
import PDFKit

class PdfView: UIViewController {
    public var documentData: Data?
    @IBOutlet weak var pdfView: PDFView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = "И.П. Лапин Е.О.                                             ИНН 220806679964"
        let titleDate = "Товарный чек № 1 дата 05.07.2020"
        let great = PDFCreator(title: title,
                               titleDate: titleDate,
                               crape: 7,
                               image: UIImage())
        documentData = great.createFlyer()
        if let data = documentData {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
        }
    }
    
    @IBAction func shared(_ sender: Any) {
        
        let title = "И.П. Лапин Е.О.                                             ИНН 220806679964"
        let titleDate = "Товарный чек № 1 дата 05.07.2020"
        let great = PDFCreator(title: title,
                               titleDate: titleDate,
                               crape: 7,
                               image: UIImage())
        let pdfData = great.createFlyer()
        let vc = UIActivityViewController(
         activityItems: [pdfData],
         applicationActivities: []
        )
        present(vc, animated: true, completion: nil)
    }
    
}
