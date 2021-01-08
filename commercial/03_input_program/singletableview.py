from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import basetable as db

class SingleHeaderView(QHeaderView):

    def __init__(self, orientation, parent=None):

        super(SingleHeaderView, self).__init__(orientation, parent)

        self.setContextMenuPolicy(Qt.ActionsContextMenu)

        self.setSectionsMovable(True)

    def set_context(self, name_list):
        for action in self.actions():
            self.removeAction(action)
        for i,name in enumerate(name_list):
            new_action = QAction(name,self)
            new_action.setCheckable(True)
            new_action.setChecked(True)
            new_action.setData(i)
            new_action.toggled.connect(self.hide_sections)
            self.addAction(new_action)

    def hide_sections(self):
        for action in self.actions():
            if action.isChecked():
                self.showSection(action.data())
            else:
                self.hideSection(action.data())


class SingleTableView(QTableView):

    def __init__(self, parent=None):
        super(SingleTableView, self).__init__(parent)

        self.setHorizontalHeader(SingleHeaderView(Qt.Horizontal, self))
