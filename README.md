# Fiestapp-iOS

COMPILAR EL PROYECTO
1) Prerrequisitos
  1.1) Instalar CocoaPods.
  Abrir el terminal y ejecutar:
    $ sudo gem install cocoapods
    
2) Requisitos
  2.1) Generar el Podfile del proyecto.
  Abrir el terminal e ir hasta el directorio raíz del proyecto y ejecutar:
    $ pod init
  2.2) Configurar los Pods del proyecto.
    Abrir con un editor de texto el archivo "Podfile", añadirle los siguientes pods y guardar los cambios:
      # Pods for fiestapp
        pod 'Firebase/Core'
  2.3) Instalar los Pods configurados.
    Ejecutar en el terminal: $ pod install
  2.4) Abrir el proyecto:
    Ejecutar en el terminal: $ open fiestapp.xcworkspace
