//
//  Menu+ActionSheet.swift
//  Sheeeeeeeeet
//
//  Created by Daniel Saidi on 2019-09-24.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import UIKit

public extension Menu {
    
    /**
     Present the menu as a custom action sheet from a custom
     view, using the default or a custom presenter.
     */
    @discardableResult
    func presentAsActionSheet(
        in vc: UIViewController,
        from view: UIView?,
        using presenter: ActionSheetPresenter = ActionSheet.defaultPresenter,
        action: @escaping ActionSheet.SelectAction) -> ActionSheet {
        let sheet = ActionSheet(menu: self, presenter: presenter, action: action)
        sheet.present(in: vc, from: view)
        return sheet
    }
    
    /**
     Present the menu as a custom action sheet from a button
     in any navigation or toolbar.
     */
    @discardableResult
    func presentAsActionSheet(
        in vc: UIViewController,
        from view: UIBarButtonItem,
        using presenter: ActionSheetPresenter = ActionSheet.defaultPresenter,
        action: @escaping ActionSheet.SelectAction) -> ActionSheet {
        let sheet = ActionSheet(menu: self, presenter: presenter, action: action)
        sheet.present(in: vc, from: view)
        return sheet
    }
    
    /**
     Convert the menu to an action sheet.
     
     This function is nice if your app implements any custom
     `Menu`s subclasses and you need to create action sheets,
     but don't want to have to call `import Sheeeeeeeeet`.
     */
    func toActionSheet(
        presenter: ActionSheetPresenter = ActionSheet.defaultPresenter,
        action: @escaping ActionSheet.SelectAction) -> ActionSheet {
        ActionSheet(menu: self, presenter: presenter, action: action)
    }
}
