# SCRUM-6: Account recovery Steam verification link fails with HTTP 404

**Status:** In Progress  
**Priority:** High  
**Reporter:** CodeSearcher6  
**Labels:** 404, account-recovery  

---

## 📝 Summary
Steam verification link у процесі відновлення акаунта ламається через некоректний редірект (`steam-external → steam-external-external`), що призводить до HTTP ERROR 404.

---

## ⚙️ Preconditions
- Ubisoft акаунт прив’язаний до Steam  
- Email недоступний  
- Recovery через Steam  

---

## 🔄 Steps to Reproduce
1. Почати Account Recovery  
2. Обрати Steam verification  
3. Відкрити email від Ubisoft Support  
4. Натиснути "Verify with Steam"  
5. Побачити редірект на некоректний URL  

---

## ✅ Expected Result
Відкривається Steam verification screen.

## ❌ Actual Result
Редірект на неіснуючу сторінку → HTTP ERROR 404.  
Steam screen не відкривається.

---

## 🌍 Environment
- Chrome, Edge, OperaGX, Steam browser  
- iPhone, Android, два ноутбуки  
- Extensions off, no VPN, cache cleared  
- Locales: en-US, uk-UA  

---

## 📎 Reference
Case No.: 26429656 (ескаловано до спеціалізованої команди)  

