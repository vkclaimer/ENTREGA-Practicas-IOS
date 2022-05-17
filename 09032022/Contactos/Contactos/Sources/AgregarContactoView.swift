//
//  AgregarContactoView.swift
//  Contactos
//
//  Created by CICE on 09/03/2022.
//

import SwiftUI
import UserNotifications

struct AgregarContactoView: View {
    
    // MARK: - ICD
    @Environment(\.managedObjectContext) private var viewContext
    @SwiftUI.Environment(\.presentationMode) var presentedMode
    
    @State private var nombre = ""
    @State private var apellido = ""
    @State private var direccion = ""
    @State private var edad = ""
    @State private var email = ""
    @State private var genero = ""
    @State private var telefono = ""
    @State private var iniciales = ""
    
    var esEdicion = false
    var data: Contacto?
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                TextField("Nombre", text: self.$nombre)
                    .textFieldStyle()
                TextField("Apellido", text: self.$apellido)
                    .textFieldStyle()
                TextField("Direccion", text: self.$direccion)
                    .textFieldStyle()
                TextField("Edad", text: self.$edad)
                    .textFieldStyle()
                    .keyboardType(.phonePad)
                TextField("Email", text: self.$email)
                    .textFieldStyle()
                    .keyboardType(.emailAddress)
                TextField("Genero", text: self.$genero)
                    .textFieldStyle()
                TextField("Telefono", text: self.$telefono)
                    .textFieldStyle()
                    .keyboardType(.phonePad)
                
                Button(action: {
                    if esEdicion {
                        self.editarContacto()
                    }else{
                        self.salvarContacto()
                        self.localNotification()
                    }
                }, label: {
                    HStack(spacing: 20){
                        Image(systemName: esEdicion ? "pencil" : "person.crop.circle")
                            .foregroundColor(.white)
                            .font(.title)
                        Text(esEdicion ? "Editar contacto" : "Guardar contacto")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                    .background(Color.blue)
                    .clipShape(Capsule())
                })
            }
            .onAppear(perform: {
                self.nombre = data?.nombre ?? ""
                self.apellido = data?.apellido ?? ""
                self.direccion = data?.direccion ?? ""
                self.email = data?.email ?? ""
                self.telefono = data?.telefono ?? ""
                self.genero = data?.genero ?? ""
                self.edad = data?.edad ?? ""
            })
            .padding(10)
        }
        .onAppear(
            
        )
        .navigationTitle("Agregar Contacto")
    }
    
    // MARK: - Private methods
    private func salvarContacto() {
        //Accedemos a la entidad que contiene la BBDD
        let nuevoContacto = Contacto(context: self.viewContext)
        let inicialN = String(self.nombre.first ?? "A")
        let inicialA = String(self.apellido.first ?? "A")
        
        nuevoContacto.nombre = self.nombre
        nuevoContacto.apellido = self.apellido
        nuevoContacto.direccion = self.direccion
        nuevoContacto.email = self.email
        nuevoContacto.telefono = self.telefono
        nuevoContacto.genero = self.genero
        nuevoContacto.edad = self.edad
        nuevoContacto.iniciales = inicialN + inicialA
        
        do{
            try self.viewContext.save()
            print("Salvado correctamente")
            self.presentedMode.wrappedValue.dismiss()
        }catch let error as NSError {
            print("Error al salvar los datos", error.localizedDescription)
        }
    }
    
    private func editarContacto(){
        let inicialN = String(self.nombre.first ?? "A")
        let inicialA = String(self.apellido.first ?? "A")
        
        self.data?.nombre = self.nombre
        self.data?.apellido = self.apellido
        self.data?.direccion = self.direccion
        self.data?.email = self.email
        self.data?.telefono = self.telefono
        self.data?.genero = self.genero
        self.data?.edad = self.edad
        self.data?.iniciales = inicialN + inicialA
        
        do{
            try self.viewContext.save()
            print("Salvado correctamente")
            self.presentedMode.wrappedValue.dismiss()
        }catch let error as NSError {
            print("Error al salvar los datos", error.localizedDescription)
        }
    }
    
    private func localNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, _) in
            //
        }
        
        // Contenido
        let contenido = UNMutableNotificationContent()
        contenido.title = "Mi Notificacion"
        contenido.subtitle = "Mi Subtitulo de notificacion"
        contenido.body = "Esta es mi primera notificacion en SwiftUI"
        contenido.sound = .defaultCritical
        contenido.badge = 1
        
        // Imagen
        if let path = Bundle.main.path(forResource: "emoji", ofType: "jpeg"){
            let url = URL(fileURLWithPath: path)
            do{
                let image = try UNNotificationAttachment(identifier: "emoji", url: url, options: nil)
                contenido.attachments = [image]
            }catch {
                print("No carga la imagen")
            }
        }
        
        // Botones
        let boton1 = UNNotificationAction(identifier: "boton1", title: "Abrir la vista detalle", options: .foreground)
        let cancel = UNNotificationAction(identifier: "cancelar", title: "Cancelar", options: .destructive)
        
        let categoria = UNNotificationCategory(identifier: "acciones", actions: [boton1, cancel], intentIdentifiers: [])
        UNUserNotificationCenter.current().setNotificationCategories([categoria])
        contenido.categoryIdentifier = "acciones"
        
        // Disparador
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "noti", content: contenido, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

struct AgregarContactoView_Previews: PreviewProvider {
    static var previews: some View {
        AgregarContactoView(data: Contacto())
    }
}
