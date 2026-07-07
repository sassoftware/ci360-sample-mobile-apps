//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: spot_request_page.dart                                                                           #
//# File Description: It Provides a full UI for making SAS CI360 Content Server Request API calls to load spot HTML content and register viewable and click events. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 5-May-2026                                                                                       #
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_sdk_flutter/mobile_sdk_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class SpotRequestPage extends StatefulWidget {
  SpotRequestPage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<SpotRequestPage> createState() => _SpotRequestPageState();
}

class _SpotRequestPageState extends State<SpotRequestPage> {
  final spotIdController = TextEditingController(text: 'flutter360Spot');
  final attrKeyController = TextEditingController();
  final attrValueController = TextEditingController();

  final Map<String, String> _attributes = {};
  bool _isLoading = false;
  bool _hasContent = false;
  bool _useWithIds = false;
  String _taskId = '';
  String _creativeId = '';
  String _recGroup = '';
  String _ci360Id = '';
  bool _isApiLoading = false;
  bool _fromCsrApi = false;
  String _requestId = '';
  String _spotKey = '';
  final contentApiUrlController = TextEditingController(
    text:
        'https://<content server api url based on region>/t/content/<tenant-Id>/id_type=_ci360_id/id_value=/spotkey=RonTestSpot',
  );
  final jwtTokenController = TextEditingController();

  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _fetchCi360Id();
  }

  void _fetchCi360Id() {
    widget.mobileSdkFlutter.getCi360Id().then((id) {
      if (mounted) {
        setState(() {
          _ci360Id = id ?? '(not available)';
        });
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          _ci360Id = 'Error: $e';
        });
      }
    });
  }

  @override
  void dispose() {
    spotIdController.dispose();
    attrKeyController.dispose();
    attrValueController.dispose();
    contentApiUrlController.dispose();
    jwtTokenController.dispose();
    super.dispose();
  }

  void _addAttribute() {
    final key = attrKeyController.text.trim();
    if (key.isNotEmpty) {
      setState(() {
        _attributes[key] = attrValueController.text.trim();
        attrKeyController.clear();
        attrValueController.clear();
      });
    }
  }

  void _removeAttribute(String key) {
    setState(() {
      _attributes.remove(key);
    });
  }

  Future<void> _requestSpotContent() async {
    final spotId = spotIdController.text.trim();
    if (spotId.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter a Spot ID');
      return;
    }

    setState(() {
      _isLoading = true;
      _hasContent = false;
      _fromCsrApi = false;
      _taskId = '';
      _creativeId = '';
      _recGroup = '';
      _requestId = '';
      _spotKey = '';
    });

    try {
      final Map<String, dynamic>? attrs = _attributes.isNotEmpty
          ? Map<String, dynamic>.from(_attributes)
          : null;

      if (_useWithIds) {
        // Content Server Request API – loadSpotDataWithIds
        // Returns spot HTML content along with task ID, creative ID and rec group
        final result = await widget.mobileSdkFlutter.loadSpotDataWithIds(
          spotId,
          attrs,
        );
        final spotData = result['content'] ?? '';
        setState(() {
          _taskId = result['taskId'] ?? '';
          _creativeId = result['creativeId'] ?? '';
          _recGroup = result['recGroup'] ?? '';
          _hasContent = spotData.isNotEmpty;
        });
        if (spotData.isNotEmpty) {
          _webViewController.loadHtmlString(spotData);
        } else {
          Fluttertoast.showToast(msg: 'No content returned for spot: $spotId');
        }
      } else {
        // Content Server Request API – loadSpotData
        // Returns spot HTML content as a string
        final html = await widget.mobileSdkFlutter.loadSpotData(spotId, attrs);
        setState(() {
          _hasContent = html.isNotEmpty;
        });
        if (html.isNotEmpty) {
          _webViewController.loadHtmlString(html);
        } else {
          Fluttertoast.showToast(msg: 'No content returned for spot: $spotId');
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error loading spot content: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _registerViewable() {
    final spotId = _fromCsrApi ? _spotKey : spotIdController.text.trim();
    if (spotId.isEmpty) return;

    if (_fromCsrApi && _taskId.isNotEmpty && _creativeId.isNotEmpty) {
      widget.mobileSdkFlutter.registerSpotViewableWithRequestId(
        spotKey: spotId,
        taskId: _taskId,
        creativeId: _creativeId,
        recGroup: _recGroup.isNotEmpty ? _recGroup : null,
        requestId: _requestId,
      );
      Fluttertoast.showToast(msg: 'Spot viewable registered (CSR API)');
    } else if (_useWithIds && _taskId.isNotEmpty && _creativeId.isNotEmpty) {
      widget.mobileSdkFlutter.registerSpotViewableWithIds(
        spotId: spotId,
        taskId: _taskId,
        creativeId: _creativeId,
        recGroup: _recGroup.isNotEmpty ? _recGroup : null,
      );
      Fluttertoast.showToast(msg: 'Spot viewable registered (with IDs)');
    } else {
      widget.mobileSdkFlutter.registerSpotViewable(spotId);
      Fluttertoast.showToast(msg: 'Spot viewable registered');
    }
  }

  void _registerClicked() {
    final spotId = _fromCsrApi ? _spotKey : spotIdController.text.trim();
    if (spotId.isEmpty) return;

    if (_fromCsrApi && _taskId.isNotEmpty && _creativeId.isNotEmpty) {
      widget.mobileSdkFlutter.registerSpotClickedWithRequestId(
        spotKey: spotId,
        taskId: _taskId,
        creativeId: _creativeId,
        recGroup: _recGroup.isNotEmpty ? _recGroup : null,
        requestId: _requestId,
      );
      Fluttertoast.showToast(msg: 'Spot click registered (CSR API)');
    } else if (_useWithIds && _taskId.isNotEmpty && _creativeId.isNotEmpty) {
      widget.mobileSdkFlutter.registerSpotClickedWithIds(
        spotId: spotId,
        taskId: _taskId,
        creativeId: _creativeId,
        recGroup: _recGroup.isNotEmpty ? _recGroup : null,
      );
      Fluttertoast.showToast(msg: 'Spot click registered (with IDs)');
    } else {
      widget.mobileSdkFlutter.registerSpotClicked(spotId);
      Fluttertoast.showToast(msg: 'Spot click registered');
    }
  }

  Future<void> _requestContentServerApi() async {
    setState(() {
      _isApiLoading = true;
      _hasContent = false;
      _fromCsrApi = false;
      _taskId = '';
      _creativeId = '';
      _recGroup = '';
      _requestId = '';
      _spotKey = '';
    });

    try {
      // Build URL – substitute CI360 ID into id_value= segment if available
      String urlStr = contentApiUrlController.text.trim();
      if (urlStr.isEmpty) {
        Fluttertoast.showToast(msg: 'Please enter a Content Server URL');
        return;
      }
      if (_ci360Id.isNotEmpty &&
          !_ci360Id.startsWith('(') &&
          !_ci360Id.startsWith('Error')) {
        urlStr = urlStr.replaceFirstMapped(
          RegExp(r'id_value=([^/]*)'),
          (_) => 'id_value=$_ci360Id',
        );
      }
      // Percent-encode brackets that may appear in the spot key
      final safeUrl = urlStr.replaceAll('[', '%5B').replaceAll(']', '%5D');
      final uri = Uri.parse(safeUrl);

      final headers = <String, String>{
        'Accept': 'application/json',
      };
      final jwt = jwtTokenController.text.trim();
      if (jwt.isNotEmpty) {
        headers['Authorization'] = 'Bearer $jwt';
      }

      final response = await http.get(uri, headers: headers);
      final body = response.body;

      if (response.statusCode != 200) {
        Fluttertoast.showToast(
            msg:
                'Content Server API error: HTTP ${response.statusCode}\n${body.substring(0, body.length.clamp(0, 120))}');
        return;
      }

      dynamic decoded;
      try {
        decoded = json.decode(body);
      } catch (_) {
        // Not JSON – render raw body directly
        setState(() {
          _fromCsrApi = true;
          _hasContent = true;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _webViewController.loadHtmlString(body);
        });
        return;
      }

      // The API returns { "contents": [...], "id_type": ..., "id_value": ... }
      // Support both a top-level array and the { "contents": [...] } envelope.
      List<dynamic> spots;
      if (decoded is List) {
        spots = decoded;
      } else if (decoded is Map && decoded['contents'] is List) {
        spots = decoded['contents'] as List<dynamic>;
      } else {
        spots = [decoded];
      }

      if (spots.isEmpty) {
        Fluttertoast.showToast(
            msg: 'No spot data returned from Content Server API');
        return;
      }

      final spot = spots[0] as Map<String, dynamic>;
      // Specifically target the 'content' field from the response
      final rawContent =
          (spot['content'] ?? spot['creative'] ?? spot['html'] ?? '')
              .toString();

      String htmlToLoad;
      if (rawContent.isNotEmpty) {
        final trimmed = rawContent.trim().toLowerCase();
        if (trimmed.startsWith('<!doctype') || trimmed.startsWith('<html')) {
          // Already a full HTML document
          htmlToLoad = rawContent;
        } else {
          // Wrap the HTML snippet in a complete document so the WebView renders it correctly
          htmlToLoad =
              '<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head><body>$rawContent</body></html>';
        }
      } else {
        // No recognised content field – render raw JSON for inspection
        final escaped = body
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;');
        htmlToLoad =
            '<html><body><pre style="font-size:11px;word-break:break-all;">$escaped</pre></body></html>';
      }

      setState(() {
        _spotKey = (spot['spot_key'] ?? spot['spotKey'] ?? '').toString();
        _taskId = (spot['task_id'] ?? spot['taskId'] ?? spot['spot_id'] ?? '')
            .toString();
        _creativeId =
            (spot['creative_id'] ?? spot['creativeId'] ?? '').toString();
        _recGroup = (spot['rec_group'] ?? spot['recGroup'] ?? '').toString();
        _requestId = (spot['request_id'] ?? spot['requestId'] ?? '').toString();
        _fromCsrApi = true;
        _hasContent = true;
      });

      // Load HTML after WebViewWidget is inserted into the tree
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _webViewController.loadHtmlString(htmlToLoad);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error calling Content Server API: $e');
    } finally {
      setState(() => _isApiLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Server Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── CI360 ID ────────────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CI360 ID (Content Server Request API)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'getCi360Id() retrieves the existing device CI360 ID used to identify returning visitors when calling the Content Server Request API.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            _ci360Id.isNotEmpty ? _ci360Id : '(not set)',
                            style: TextStyle(
                              fontSize: 13,
                              color: _ci360Id.isNotEmpty
                                  ? Colors.black87
                                  : Colors.grey,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _fetchCi360Id,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Get CI360 ID'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── Spot configuration ──────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Spot Configuration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: spotIdController,
                      decoration: const InputDecoration(
                        labelText: 'Spot ID',
                        border: OutlineInputBorder(),
                        hintText: 'Enter the spot ID',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Use loadSpotDataWithIds\n(returns task/creative IDs)',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Switch(
                          value: _useWithIds,
                          onChanged: (v) => setState(() {
                            _useWithIds = v;
                            _hasContent = false;
                            _taskId = '';
                            _creativeId = '';
                            _recGroup = '';
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── Custom attributes ───────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Custom Attributes (optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: attrKeyController,
                            decoration: const InputDecoration(
                              labelText: 'Key',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: attrValueController,
                            decoration: const InputDecoration(
                              labelText: 'Value',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.blue,
                          ),
                          onPressed: _addAttribute,
                          tooltip: 'Add attribute',
                        ),
                      ],
                    ),
                    if (_attributes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Divider(),
                      ..._attributes.entries.map(
                        (e) => Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${e.key}: ${e.value}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () => _removeAttribute(e.key),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Request button ──────────────────────────────────────────────
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _requestSpotContent,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download),
              label: Text(_isLoading ? 'Loading...' : 'Request Spot Content'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 8),

            // ── Content Server Request API (Direct HTTP) ────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Content Server Request API (Direct HTTP)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Makes a direct HTTP GET to the CI360 Content Server. '
                      'The CI360 ID is automatically inserted into id_value= if available.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: contentApiUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Content Server URL',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: jwtTokenController,
                      decoration: const InputDecoration(
                        labelText: 'JWT Token (Bearer)',
                        border: OutlineInputBorder(),
                        hintText: 'Paste JWT token from event access point',
                      ),
                      maxLines: 3,
                      style: const TextStyle(fontSize: 12),
                      obscureText: false,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed:
                          _isApiLoading ? null : _requestContentServerApi,
                      icon: _isApiLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.api),
                      label: Text(
                          _isApiLoading ? 'Loading...' : 'Content Request API'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── Returned IDs ────────────────────────────────────────────────
            if ((_useWithIds || _fromCsrApi) && _hasContent) ...[
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Returned IDs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_spotKey.isNotEmpty)
                        SelectableText('Spot Key: $_spotKey'),
                      if (_taskId.isNotEmpty)
                        SelectableText('Task ID: $_taskId'),
                      if (_creativeId.isNotEmpty)
                        SelectableText('Creative ID: $_creativeId'),
                      if (_recGroup.isNotEmpty)
                        SelectableText('Rec Group: $_recGroup'),
                      if (_requestId.isNotEmpty)
                        SelectableText('Request ID: $_requestId'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // ── Spot content (WebView) ──────────────────────────────────────
            if (_hasContent) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Spot Content',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: WebViewWidget(controller: _webViewController),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ── Event tracking ─────────────────────────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Event Tracking',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _fromCsrApi
                            ? 'Uses registerSpotViewableWithRequestId / registerSpotClickedWithRequestId'
                            : _useWithIds
                                ? 'Uses registerSpotViewableWithIds / registerSpotClickedWithIds'
                                : 'Uses registerSpotViewable / registerSpotClicked',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _registerViewable,
                              icon: const Icon(Icons.visibility),
                              label: const Text('Register Viewable'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _registerClicked,
                              icon: const Icon(Icons.touch_app),
                              label: const Text('Register Clicked'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
