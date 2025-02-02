import firebase_admin
from firebase_admin import credentials, firestore

class FirebaseService:
    def __init__(self, credential_path):
        self.cred = credentials.Certificate(credential_path)
        try:
            firebase_admin.initialize_app(self.cred)
        except:
            pass
        self.db = firestore.client()

    def insertar_documento(self, coleccion, documento_id, datos):
        doc_ref = self.db.collection(coleccion).document(documento_id) if documento_id else self.db.collection(coleccion).document()
        doc_ref.set(datos)
        return doc_ref.id

    def obtener_documento(self, coleccion, documento_id):
        col_ref = self.db.collection(coleccion)

        if documento_id == "":
            docs = col_ref.stream()
        else:
            query = col_ref.where(filter=firestore.FieldFilter("id", "==", documento_id))
            docs = query.stream()

        resultados = []
        for doc in docs:
            data = doc.to_dict()
            data["id"] = doc.id
            resultados.append(data)
        return resultados if resultados else None

    def obtener_coleccion(self, coleccion):
        docs = self.db.collection(coleccion).stream()
        return [{doc.id: doc.to_dict()} for doc in docs]

    def actualizar_documento(self, coleccion, documento_id, datos):
        doc_ref = self.db.collection(coleccion).document(documento_id)
        doc_ref.update(datos)

    def eliminar_documento(self, coleccion, documento_id):
        doc_ref = self.db.collection(coleccion).document(documento_id)
        doc_ref.delete()