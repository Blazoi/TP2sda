from PyQt5.QtWidgets import (
    QApplication,
    QWidget,
    QLabel,
    QLineEdit,
    QPushButton,
    QVBoxLayout,
    QHBoxLayout
)
import oracledb as db


app = QApplication([])
class Window(QWidget):
    def __init__(self, parent):
        super().__init__()
        self.setWindowTitle("Base de données hopital_db_jad")
        self.setFixedSize(400,400)

        self.mainLayout = QVBoxLayout()

        self.userLayout = QHBoxLayout()
        self.userLabel = QLabel("Utilisateur: ")
        self.userEntry = QLineEdit("hopital_schema_jad")
        self.userLayout.addWidget(self.userLabel)
        self.userLayout.addWidget(self.userEntry)

        self.pswdLayout = QHBoxLayout()
        self.pswdLabel = QLabel("Mot de Passe: ")
        self.pswdEntry = QLineEdit("oracle")
        self.pswdLayout.addWidget(self.pswdLabel)
        self.pswdLayout.addWidget(self.pswdEntry)

        self.dsnLayout = QHBoxLayout()
        self.dsnLabel = QLabel("DSN: ")
        self.dsnEntry = QLineEdit("1521")
        self.dsnLayout.addWidget(self.dsnLabel)
        self.dsnLayout.addWidget(self.dsnEntry)

        self.mainLayout.addLayout(self.userLayout)
        self.mainLayout.addLayout(self.pswdLayout)
        self.mainLayout.addLayout(self.dsnLayout)

        self.btnCnxn = QPushButton("Se Connecter")
        self.btnCnxn.clicked.connect(self.connection(parent=parent))
        self.mainLayout.addWidget(self.btnCnxn)
        self.setLayout(self.mainLayout)
        
    def connection(self, parent):
        self.user = self.userEntry.text()
        self.pswd = self.pswdEntry.text()
        self.dsn = self.dsnEntry.text()
        
        try:
            connection = db.connect(user=self.user, password=self.pswd, dsn=self.dsn)
            parent.goDonnees()
        except:
            print("erreur")
        
        
        print(f'USER : {self.user},\nPSWD : {self.pswd},\nDSN  : {self.dsn}')


win = Window()
win.show()
app.exec_()