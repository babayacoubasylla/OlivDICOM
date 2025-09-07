# 🌿 OlivDICOM

> **Système de partage sécurisé d’images médicales DICOM pour les Paracliniques Les Oliviers — Gagnoa → Abidjan**

---

## ✅ Fonctionnalités

- Upload d’images DICOM (scanner, IRM, etc.)
- Visualisation en ligne via OHIF Viewer (navigateur web)
- Accès sécurisé HTTPS
- Partage facile avec les médecins (lien unique)
- Hébergement gratuit via Render.com

---

## 🚀 Déploiement (100% gratuit, sans Docker local)

1. Fork ce dépôt (optionnel)
2. Va sur [Render.com](https://render.com) → “New Web Service”
3. Connecte ton compte GitHub → sélectionne ce dépôt (`OlivDICOM`)
4. Type : **Docker**
5. Plan : **Free**
6. Clique “Create Web Service”
7. Attends 5-7 min → ton lien est actif : `https://olivdicom.onrender.com`

---

## 🖼️ Utilisation

1. **Uploader une étude** :  
   → Ouvre : `https://olivdicom.onrender.com/orthanc`  
   → Clique “Upload” → sélectionne un dossier contenant tes fichiers `.dcm`

2. **Visualiser les études** :  
   → Ouvre : `https://olivdicom.onrender.com`  
   → Sélectionne l’étude → visualise, zoome, mesure

3. **Partager avec un médecin** :  
   → Envoie-lui simplement : `https://olivdicom.onrender.com`

---

## 🔐 Sécurité

- HTTPS activé automatiquement par Render
- Anonymisation manuelle recommandée avant upload (utilise Google Colab → voir plus bas)

---

## 🧪 Anonymiser tes DICOM (optionnel, mais fortement recommandé)

1. Va sur → [Google Colab](https://colab.research.google.com/)
2. Crée un nouveau notebook
3. Colle ce code :

```python
!pip install pydicom

from google.colab import files
import pydicom

uploaded = files.upload()

for filename in uploaded.keys():
    ds = pydicom.dcmread(filename)
    ds.PatientName = "PatientAnonyme"
    ds.PatientID = "ANON_" + filename.split('.')[0]
    ds.save_as("ANONYMIZED_" + filename)
    print(f"✅ {filename} → ANONYMIZED_{filename}")
    files.download("ANONYMIZED_" + filename)