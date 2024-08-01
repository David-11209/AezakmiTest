//
//  ViewModel.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 30.07.2024.
//

import SwiftUI
import Firebase
import GoogleSignIn

final class AuthorizationViewModel: NSObject, ObservableObject {

//    private var currentUser: GIDGoogleUser?
    func signInWithGoogle() async -> Bool {
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            return false
        }

        let config = GIDConfiguration(clientID: clientId)

        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            return false
        }

        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                print("нет idToken")
                 return false
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            return true
        }
        catch {
            print(error.localizedDescription)
            return false
        }
    }

    func signInWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
            if error != nil {
                completion(false, "")
                return
            }

            completion(true, (res?.user.email)!)
        }
    }

    func isEmailUnique(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if let error = error {
                print("Ошибка при проверке email: \(error.localizedDescription)")
                completion(false) // В случае ошибки считаем email не уникальным
                return
            }

            // Если methods пуст, то email уникален
            completion(methods?.isEmpty ?? true)
        }
    }

    // Функция для регистрации пользователя
    func signUpWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            if let error = error {
                print("Ошибка при регистрации: \(error.localizedDescription)")
                completion(false, "")
                return
            }
            completion(true, email)

            // Регистрация успешна

        }
    }

    func resetPassword(email: String) {
        guard !email.isEmpty else {
            print("Пожалуйста, введите email.")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
               print(error.localizedDescription)
            } else {
                print("Письмо для сброса пароля отправлено на \(email).")
            }
        }
    }

    // TODO: Это должно быть приватным. Используется только внутри. При проверке пользуйся 4 вкладкой (Поиск по проекту)
    func sendEmailVerification(completion: @escaping (Bool, String) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, "Пользователь не найден.")
            return
        }

        user.sendEmailVerification { error in
            if let error = error {
                print("Ошибка при отправке письма с подтверждением: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            // Письмо отправлено успешно
            completion(true, "Письмо с подтверждением отправлено на \(user.email ?? ""). Проверьте свой почтовый ящик.")
        }
    }

    // Функция для проверки подтверждения email
    func checkEmailVerification(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        Auth.auth().currentUser?.reload()
        if user.isEmailVerified {
            completion(user.isEmailVerified)
        } else {
            completion(false)
            return
        }
    }
}
//
//self.checkEmailVerification { res in
//    if res {
//        completion(true, email)
//    } else {
//        guard let user = Auth.auth().currentUser else { return }
//        user.delete()
//        completion(false, "")
//    }
//}