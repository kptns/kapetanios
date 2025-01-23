import firebase_admin
from firebase_admin import credentials, firestore

class FirebaseService:
    def __init__(self, credential_path):
        """
        Inicializa la conexión con Firebase.

        :param credential_path: Ruta al archivo JSON con las credenciales de Firebase
        """
        self.cred = credentials.Certificate(credential_path)
        firebase_admin.initialize_app(self.cred)
        self.db = firestore.client()

    def insertar_documento(self, coleccion, documento_id, datos):
        """
        Inserta un documento en una colección de Firestore.

        :param coleccion: Nombre de la colección
        :param documento_id: ID del documento (puede ser None para generar automáticamente)
        :param datos: Diccionario con los datos a guardar
        """
        doc_ref = self.db.collection(coleccion).document(documento_id) if documento_id else self.db.collection(coleccion).document()
        doc_ref.set(datos)
        return doc_ref.id

    def obtener_documento(self, coleccion, documento_id):
        """
        Obtiene un documento por su ID.

        :param coleccion: Nombre de la colección
        :param documento_id: ID del documento a obtener
        :return: Diccionario con los datos del documento o None si no existe
        """
        doc_ref = self.db.collection(coleccion).document(documento_id)
        doc = doc_ref.get()
        if doc.exists:
            return doc.to_dict()
        else:
            return None

    def obtener_coleccion(self, coleccion):
        """
        Obtiene todos los documentos de una colección.

        :param coleccion: Nombre de la colección
        :return: Lista de documentos (diccionarios)
        """
        docs = self.db.collection(coleccion).stream()
        return [{doc.id: doc.to_dict()} for doc in docs]

    def actualizar_documento(self, coleccion, documento_id, datos):
        """
        Actualiza un documento existente en Firestore.

        :param coleccion: Nombre de la colección
        :param documento_id: ID del documento a actualizar
        :param datos: Diccionario con los campos a actualizar
        """
        doc_ref = self.db.collection(coleccion).document(documento_id)
        doc_ref.update(datos)

    def eliminar_documento(self, coleccion, documento_id):
        """
        Elimina un documento por su ID.

        :param coleccion: Nombre de la colección
        :param documento_id: ID del documento a eliminar
        """
        doc_ref = self.db.collection(coleccion).document(documento_id)
        doc_ref.delete()