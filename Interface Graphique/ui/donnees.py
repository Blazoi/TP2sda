from PyQt5.QtWidgets import (
    QApplication,
    QWidget,
    QTableWidget,
    QTableWidgetItem,
    QLabel,
    QLineEdit,
    QTextEdit,
    QPushButton,
    QVBoxLayout,
    QHBoxLayout,
)
import oracledb as db


class Window(QWidget):
    def __init__(self, info_conn=["hopital_schema_jad", "oracle", 1521]):
        super().__init__()
        self.setWindowTitle("Base de données hopital_db_jad")
        self.setFixedSize(400, 400)

        self.mainLayout = QVBoxLayout()

        self.table = QTableWidget()
        self.table.setColumnCount(4)
        self.table.setRowCount(5)
        # Titres des colonnes
        self.table.setItem(0, 0, QTableWidgetItem("ID patient"))
        self.table.setItem(0, 1, QTableWidgetItem("Nom"))
        self.table.setItem(0, 2, QTableWidgetItem("Prenom"))
        self.table.setItem(0, 3, QTableWidgetItem("Sexe"))
        # Cursor pour récupérer les données
        self.cursor = db.connect(user=info_conn[0], password=info_conn[1], dsn=info_conn[2]).cursor()
        self.cursor.execute(f'select * from patients_jad')
        # Remplit le tableau
        rangee = 1
        for c_id, c_nom, c_prenom, c_sexe in self.cursor:
            colonne = 0
            self.table.setItem(rangee, colonne, QTableWidgetItem(str(c_id)))
            colonne += 1
            self.table.setItem(rangee, colonne, QTableWidgetItem(c_nom))
            colonne += 1
            self.table.setItem(rangee, colonne, QTableWidgetItem(c_prenom))
            colonne += 1
            self.table.setItem(rangee, colonne, QTableWidgetItem(c_sexe))
            rangee += 1
        self.mainLayout.addWidget(self.table)

        self.rechercheLayout = QVBoxLayout()

        # Création des widgets de recherche
        self.rechercheInfoLayout = QHBoxLayout()
        self.rechercheInfoBouton = QPushButton("Chercher")
        self.rechercheInfoBouton.clicked.connect(self.chercherInfo)
        self.rechercheInfoLabel = QLabel("Informations recherchées")
        self.rechercheInfoEntry = QLineEdit()
        self.rechercheInfoEntryID = QLineEdit()
        self.rechercheInfoEntryID.setPlaceholderText("ID DU PATIENT")
        self.rechercheInfoLayout.addWidget(self.rechercheInfoLabel)
        self.rechercheInfoLayout.addWidget(self.rechercheInfoEntry)
        self.rechercheInfoLayout.addWidget(self.rechercheInfoEntryID)
        self.rechercheInfoLayout.addWidget(self.rechercheInfoBouton)

        self.rechercheMDPLayout = QHBoxLayout()
        self.rechercheMDPLabel = QLabel("Mot de Passe")
        self.rechercheMDPEntry = QLineEdit("freeTP2")

        self.rechercheMDPLayout.addWidget(self.rechercheMDPLabel)
        self.rechercheMDPLayout.addWidget(self.rechercheMDPEntry)
        self.rechercheLayout.addLayout(self.rechercheInfoLayout)
        self.rechercheLayout.addLayout(self.rechercheMDPLayout)
        self.mainLayout.addLayout(self.rechercheLayout)

        self.infoLayout = QHBoxLayout()
        self.infoLabel = QLabel("Info:")
        self.infoEntry = QTextEdit()
        self.infoEntry.setReadOnly(True)
        self.infoLayout.addWidget(self.infoLabel)
        self.infoLayout.addWidget(self.infoEntry)
        self.mainLayout.addLayout(self.infoLayout)

        self.setLayout(self.mainLayout)

    def chercherInfo(self):

        free = "freeTP2"

        id = self.rechercheInfoEntryID.text()
        info = self.rechercheInfoEntry.text()
        mdp = self.rechercheMDPEntry.text()

        if mdp != free:
            print("Mot de passe incorrect")
            return

        try:
            # Variables bind out
            date_naissance = self.cursor.var(db.STRING)
            adresse = self.cursor.var(db.STRING)
            num_secu = self.cursor.var(db.STRING)
            diagnostic = self.cursor.var(db.STRING)
            traitement = self.cursor.var(db.STRING)
            rapport_consultation = self.cursor.var(db.STRING)
            cout_consultation = self.cursor.var(db.NUMBER)
            
            # Appel de la procédure de décryptage
            self.cursor.callproc(
                "crypto_jad.decrypt_data",
                [
                    id,
                    mdp,
                    date_naissance,
                    adresse,
                    num_secu,
                    diagnostic,
                    traitement,
                    rapport_consultation,
                    cout_consultation,
                ],
            )

            # Dictionnaire pour accéder aux variables bind out
            info_dict = {
                "date_naissance": date_naissance,
                "adresse": adresse,
                "num_secu": num_secu,
                "diagnostic": diagnostic,
                "traitement": traitement,
                "rapport_consultation": rapport_consultation,
                "cout_consultation": cout_consultation,
            }
            
            # Retour et affichage de l'info recherchée
            infoRetour = [v for k,v in info_dict.items() if k == info][0]
            self.infoEntry.setText(str(infoRetour.getvalue()))
        except:
            print("erreur")


app = QApplication([])
win = Window()
win.show()
app.exec_()
