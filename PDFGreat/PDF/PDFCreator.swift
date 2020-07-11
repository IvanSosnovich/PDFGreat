//
//  PDFCreator.swift
//  PDFGreat
//
//  Created by MIkkyMouse on 10.07.2020.
//  Copyright © 2020 Ivan Sosnovich. All rights reserved.
//
//21 ширина
//15 высота
import UIKit
import PDFKit

class PDFCreator: NSObject {
    
    let title: String
    let titleDate: String
    let crape: Int
    let image: UIImage
    
    init(title: String, titleDate: String, crape: Int, image: UIImage) {
        self.title = title
        self.titleDate = titleDate
        self.crape = crape
        self.image = image
    }
    
    func createFlyer() -> Data {
        // 1 Вы создаете словарь с метаданными PDF, используя предварительно определенные ключи. Вы можете найти полный список ключей в компании Apple Вспомогательные Ключи Словаря. Чтобы задать метаданные, необходимо создать UIGraphicsPDFRendererFormat объект и назначить словарь для documentInfo.
        let pdfMetaData = [
            kCGPDFContextCreator: "Flyer Builder",
            kCGPDFContextAuthor: "raywenderlich.com",
            kCGPDFContextTitle: title
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as[ String: Any]
        
        // 2 Напомним, что PDF-файлы используют систему координат с 72 точками на дюйм. Чтобы создать PDF-документ с определенным размером, умножьте размер в дюймах на 72, чтобы получить количество точек. Здесь вы будете использовать 8,5 х 11 дюймов, потому что это стандартный размер буквы США. Затем вы создадите прямоугольник только что вычисленного размера.
        let pageWidth = 8.27 * 72.0
        let pageHeight = 11.69 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        // 3 UIGraphicsPDFRenderer(bounds:format:) создает a PDFRenderer объект с размерами прямоугольника и форматом, содержащим метаданные.
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        // 4 pdfData(actions:) включает в себя блок, где вы создаете PDF. Средство визуализации создает основной графический контекст, который становится текущим контекстом внутри блока. Чертеж, выполненный в этом контексте, появится в PDF-файле
        let data = renderer.pdfData { (context) in
            // 5 context.beginPage() запускает новую страницу PDF. Вы должны позвонить beginPage() один раз, прежде чем давать какие-либо другие инструкции по рисованию. Вы можете вызвать его снова, чтобы создать многостраничные PDF-документы.
            context.beginPage()
            // 6 С помощью draw(at:withAttributes:) на String выводит строку в текущий контекст. Вы устанавливаете размер строки до 72 точек. %%%%%%%
            let title = addTitle(pageRect: pageRect)
            let titleDate = addTitleDate(pageRect: pageRect)
            let context = context.cgContext
            drawTearOffs(context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0,
                         numberTabs: crape)
            
        }
        
        return data
    }
    
    func addTitle(pageRect: CGRect) -> CGFloat {
        // 1 Вы создаете экземпляр системного шрифта, который имеет размер 18 точек и выделен жирным шрифтом.
        let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        // 2 Вы создаете словарь атрибутов и устанавливаете NSAttributedString.Клавиша.шрифт ключ к этому шрифту.
        let titleAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: titleFont]
        // 3 Затем вы создаете NSAttributedString содержит текст заголовка в выбранном шрифте.
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: titleAttributes
        )
        // 4 С помощью size() на атрибутивной строке возвращает прямоугольник с размером, который будет занимать текст в текущем контексте.
        let titleStringSize = attributedTitle.size()
        // 5 Теперь вы создаете прямоугольник 36 точек от верхней части страницы, который горизонтально центрирует заголовок на странице. На приведенном ниже рисунке показано, как рассчитать x координаты, необходимые для центрирования текста. Вычитание ширины строки из ширины страницы, чтобы вычислить оставшееся пространство. Деление этой суммы на две равномерно разбивает пространство на каждой стороне текста
        let titleStringRect = CGRect(
            x: (pageRect.width - titleStringSize.width) / 2.0,
            y: 36,
            width: titleStringSize.width,
            height: titleStringSize.height
        )
        // 6 С помощью draw(in:) на NSAttributedString рисует его внутри прямоугольника.
        attributedTitle.draw(in: titleStringRect)
        // 7 Этот код добавляет: y координата прямоугольника к высоте прямоугольника, чтобы найти координату нижней части прямоугольника, как показано на следующем рисунке. Затем код возвращает эту координату вызывающему объекту.
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    func addTitleDate(pageRect: CGRect) -> CGFloat {
        // 1 Вы создаете экземпляр системного шрифта, который имеет размер 18 точек и выделен жирным шрифтом.
        let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        // 2 Вы создаете словарь атрибутов и устанавливаете NSAttributedString.Клавиша.шрифт ключ к этому шрифту.
        let titleAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: titleFont]
        // 3 Затем вы создаете NSAttributedString содержит текст заголовка в выбранном шрифте.
        let attributedTitle = NSAttributedString(
            string: titleDate,
            attributes: titleAttributes
        )
        // 4 С помощью size() на атрибутивной строке возвращает прямоугольник с размером, который будет занимать текст в текущем контексте.
        let titleStringSize = attributedTitle.size()
        // 5 Теперь вы создаете прямоугольник 36 точек от верхней части страницы, который горизонтально центрирует заголовок на странице. На приведенном ниже рисунке показано, как рассчитать x координаты, необходимые для центрирования текста. Вычитание ширины строки из ширины страницы, чтобы вычислить оставшееся пространство. Деление этой суммы на две равномерно разбивает пространство на каждой стороне текста
        let titleStringRect = CGRect(
            x: (pageRect.width - titleStringSize.width) / 2.0,
            y: 80,
            width: titleStringSize.width,
            height: titleStringSize.height
        )
        // 6 С помощью draw(in:) на NSAttributedString рисует его внутри прямоугольника.
        attributedTitle.draw(in: titleStringRect)
        // 7 Этот код добавляет: y координата прямоугольника к высоте прямоугольника, чтобы найти координату нижней части прямоугольника, как показано на следующем рисунке. Затем код возвращает эту координату вызывающему объекту.
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    // 1 Этот новый метод принимает несколько параметров. Сначала идет графический контекст для рисования (больше об этом через мгновение), а затем прямоугольник для страницы. Вы также передаете расположение для верхней части вкладок вместе с количеством вкладок для создания.
    func drawTearOffs( _  drawContext: CGContext, pageRect: CGRect,
                       tearOffY: CGFloat, numberTabs: Int) {
        // 2 Вы сохраняете текущее состояние графического контекста. Позже вы восстановите контекст, отменяя все изменения, внесенные между двумя вызовами. Это сопряжение обеспечивает согласованность среды в начале каждого шага.
        drawContext.saveGState()
        // 3 Затем код устанавливает ширину штриховых линий в две точки.
        drawContext.setLineWidth(2.0)
        
        // 4 Затем вы рисуете горизонтальную линию слева направо от страницы на пройденной высоте, а затем восстанавливаете состояние, сохраненное ранее.
        drawContext.move(to: CGPoint(x: 15, y: 115))
        drawContext.addLine(to: CGPoint(x: 590, y: 115))
        drawContext.strokePath()
        
        drawContext.move(to: CGPoint(x: 15, y: 150))
        drawContext.addLine(to: CGPoint(x: 15, y: 115))
        drawContext.strokePath()
        
        drawContext.move(to: CGPoint(x: 15, y: 150))
        drawContext.addLine(to: CGPoint(x: 590, y: 150))
        drawContext.strokePath()
        
        drawContext.move(to: CGPoint(x: 590, y: 150))
        drawContext.addLine(to: CGPoint(x: 590, y: 115))
        drawContext.strokePath()
        
        drawContext.move(to: CGPoint(x: 50, y: 150))
        drawContext.addLine(to: CGPoint(x: 50, y: 115))
        drawContext.strokePath()
        
           let attributes = [
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
        
        let attributes1 = [
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)
        ]
        
        let text = "№"
        text.draw(at: CGPoint(x: 20, y: 120), withAttributes: attributes)
        //горизонт
        drawContext.move(to: CGPoint(x: 350, y: 150))
        drawContext.addLine(to: CGPoint(x: 350, y: 115))
        drawContext.strokePath()
        
        let text1 = "Наименование товара"
               text1.draw(at: CGPoint(x: 80, y: 120), withAttributes: attributes)
        
        drawContext.move(to: CGPoint(x: 480, y: 150))
        drawContext.addLine(to: CGPoint(x: 480, y: 115))
        drawContext.strokePath()
        
        let text2 = "Кол-во"
        text2.draw(at: CGPoint(x: 353, y: 125), withAttributes: attributes1)
        
        drawContext.move(to: CGPoint(x: 410, y: 150))
        drawContext.addLine(to: CGPoint(x: 410, y: 115))
        drawContext.strokePath()
        
        let text3 = "Цена"
        text3.draw(at: CGPoint(x: 430, y: 125), withAttributes: attributes1)
        
        let text4 = "Сумма"
        text4.draw(at: CGPoint(x: 510, y: 125), withAttributes: attributes1)
        
        drawContext.restoreGState()
       
        for crapeUse in 1...numberTabs {
            var distanse = 35 * crapeUse
            drawContext.move(to: CGPoint(x: 15, y: 115 + distanse))
            drawContext.addLine(to: CGPoint(x: 590, y: 115 + distanse))
            drawContext.strokePath()
            
            drawContext.move(to: CGPoint(x: 15, y: 150 + distanse))
            drawContext.addLine(to: CGPoint(x: 15, y: 115 + distanse))
            drawContext.strokePath()
            
            drawContext.move(to: CGPoint(x: 15, y: 150 + distanse))
            drawContext.addLine(to: CGPoint(x: 590, y: 150 + distanse))
            drawContext.strokePath()
            
            drawContext.move(to: CGPoint(x: 590, y: 150 + distanse))
            drawContext.addLine(to: CGPoint(x: 590, y: 115 + distanse))
            drawContext.strokePath()
            
            drawContext.move(to: CGPoint(x: 50, y: 150 + distanse))
            drawContext.addLine(to: CGPoint(x: 50, y: 115 + distanse))
            drawContext.strokePath()
            
               let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
            ]
            
            let attributes1 = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)
            ]
            
            let text = "\(0 + crapeUse)"
            text.draw(at: CGPoint(x: 20, y: 120 + distanse), withAttributes: attributes)
            //горизонт
            drawContext.move(to: CGPoint(x: 350, y: 150 + distanse))
            drawContext.addLine(to: CGPoint(x: 350, y: 115 + distanse))
            drawContext.strokePath()
            
            let text1 = "Дисплей айфон 7 оригинал"
                   text1.draw(at: CGPoint(x: 80, y: 120 + distanse), withAttributes: attributes)
            
            drawContext.move(to: CGPoint(x: 480, y: 150 + distanse))
            drawContext.addLine(to: CGPoint(x: 480, y: 115 + distanse))
            drawContext.strokePath()
            
            let text2 = "1"
            text2.draw(at: CGPoint(x: 373, y: 125 + distanse), withAttributes: attributes1)
            
            drawContext.move(to: CGPoint(x: 410, y: 150 + distanse))
            drawContext.addLine(to: CGPoint(x: 410, y: 115 + distanse))
            drawContext.strokePath()
            
            let text3 = "250000"
            text3.draw(at: CGPoint(x: 415, y: 125 + distanse), withAttributes: attributes1)
            
            let text4 = "250000"
            text4.draw(at: CGPoint(x: 510, y: 125 + distanse), withAttributes: attributes1)
            
            if crapeUse == numberTabs {
                distanse += 35
                drawContext.move(to: CGPoint(x: 15, y: 115 + distanse))
                           drawContext.addLine(to: CGPoint(x: 590, y: 115 + distanse))
                           drawContext.strokePath()
                           
                           drawContext.move(to: CGPoint(x: 15, y: 150 + distanse))
                           drawContext.addLine(to: CGPoint(x: 15, y: 115 + distanse))
                           drawContext.strokePath()
                           
                           drawContext.move(to: CGPoint(x: 15, y: 150 + distanse))
                           drawContext.addLine(to: CGPoint(x: 590, y: 150 + distanse))
                           drawContext.strokePath()
                           
                           drawContext.move(to: CGPoint(x: 590, y: 150 + distanse))
                           drawContext.addLine(to: CGPoint(x: 590, y: 115 + distanse))
                           drawContext.strokePath()
                           
                           
                              let attributes = [
                           NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
                           ]
                           
                           let attributes1 = [
                           NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)
                           ]
                           
                           let text = "Всего"
                           text.draw(at: CGPoint(x: 20, y: 120 + distanse), withAttributes: attributes)
                           //горизонт
                           drawContext.move(to: CGPoint(x: 350, y: 150 + distanse))
                           drawContext.addLine(to: CGPoint(x: 350, y: 115 + distanse))
                           drawContext.strokePath()
                          
                           drawContext.move(to: CGPoint(x: 480, y: 150 + distanse))
                           drawContext.addLine(to: CGPoint(x: 480, y: 115 + distanse))
                           drawContext.strokePath()
                           
                           let text2 = "\(crapeUse)"
                           text2.draw(at: CGPoint(x: 373, y: 125 + distanse), withAttributes: attributes1)
                           
                           drawContext.move(to: CGPoint(x: 410, y: 150 + distanse))
                           drawContext.addLine(to: CGPoint(x: 410, y: 115 + distanse))
                           drawContext.strokePath()
                           
                           let text3 = ""
                           text3.draw(at: CGPoint(x: 415, y: 125 + distanse), withAttributes: attributes1)
                           
                           let text4 = "250000"
                           text4.draw(at: CGPoint(x: 510, y: 125 + distanse), withAttributes: attributes1)
                
                // итоговая шапка
                distanse += 50
                let text8 = "Итого на сумму: пятнадцать тысяч рублей 00 коп."
                text8.draw(at: CGPoint(x: 20, y: 120 + distanse), withAttributes: attributes)
                
                distanse += 50
                let text5 = "Отпустил:"
                text5.draw(at: CGPoint(x: 20, y: 120 + distanse), withAttributes: attributes)
                
                drawContext.move(to: CGPoint(x: 20, y: 145 + distanse))
                drawContext.addLine(to: CGPoint(x: 300, y: 145 + distanse))
                drawContext.strokePath()
                
                let text6 = "Получил:"
                text6.draw(at: CGPoint(x: 350, y: 120 + distanse), withAttributes: attributes)
                
                drawContext.move(to: CGPoint(x: 350, y: 145 + distanse))
                drawContext.addLine(to: CGPoint(x: 590, y: 145 + distanse))
                drawContext.strokePath()
                
                distanse += 50
                let text7 = "М.П."
                text7.draw(at: CGPoint(x: 20, y: 120 + distanse), withAttributes: attributes)
            }
        }

        
        drawContext.restoreGState()
    }
    
    
}
